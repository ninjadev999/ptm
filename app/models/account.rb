# frozen_string_literal: true
# == Schema Information
#
# Table name: accounts
#
#  id                              :bigint(8)        not null, primary key
#  address_line1                   :string
#  address_line2                   :string
#  audio_download_formats          :integer          default("wav_only")
#  audio_visual_download_options   :integer          default("audio_only")
#  city                            :string
#  country                         :string
#  description                     :text
#  downloads_per_episode           :bigint(8)
#  interviewer                     :boolean          default(FALSE)
#  max_resolution                  :integer          default("resolution_720p")
#  max_units                       :integer          default(1), not null
#  name                            :string
#  social_media_followers          :bigint(8)
#  state                           :string
#  time_zone                       :string
#  wants_help_finding_interviewees :boolean          default(FALSE)
#  zip_code                        :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  admin_id                        :integer
#  stripe_customer_id              :string
#
# Indexes
#
#  index_accounts_on_admin_id            (admin_id)
#  index_accounts_on_stripe_customer_id  (stripe_customer_id)
#

class Account < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  attribute :remove_logo, :boolean, default: false

  belongs_to :admin, class_name: "User", required: true
  has_one_attached :logo
  has_many :account_users, dependent: :delete_all
  has_many :users, through: :account_users

  has_many :host_solicited_interviews, dependent: :destroy, class_name: 'SolicitedInterview'
  has_many :host_interviews, dependent: :destroy, class_name: 'HostInterview'
  has_many :interviews, dependent: :destroy

  has_many :members, foreign_key: :account_id, class_name: 'Invite'
  has_many :invites, -> { except_applications }, foreign_key: :account_id, class_name: 'Invite'
  has_many :applicants, -> { applications }, foreign_key: :account_id, class_name: 'Invite'

  has_many :podcast_invites

  has_many :account_public_sites, inverse_of: :account, dependent: :destroy
  accepts_nested_attributes_for :account_public_sites, reject_if: :all_blank, allow_destroy: true

  has_many :account_social_sites, inverse_of: :account, dependent: :destroy
  accepts_nested_attributes_for :account_social_sites, reject_if: :all_blank, allow_destroy: true

  enum max_resolution: { standard_definition: 0, resolution_720p: 1, resolution_1080p: 2 }
  enum audio_visual_download_options: { video_and_audio: 0, audio_only: 1 }
  enum audio_download_formats: { wav_only: 0, mp3_only: 1 }

  validates_presence_of :time_zone, :name

  after_commit on: :create do
    AccountUser.create!(user: self.admin, account: self)
  end

  before_update :handle_logo_removal
  ratyrate_rater
  ratyrate_rateable 'comfortable', 'technique', 'interests', 'recommend'
  
  settings do
    mappings dynamic: 'false' do
      indexes :most_topics, type: :keyword
      indexes :most_promotions, type: :keyword
      indexes :most_expertises, type: :keyword
    end
  end

  ############# ElasticSearch #################
  def self.search_for(*args,&block)
    __elasticsearch__.search(*args, &block)
  end

  def as_json(options={})
    json = super(options)
    json[:most_topics] = most_topics
    json[:most_promotions] = most_promotions
    json[:most_expertises] = most_expertises
    json
  end

  def most_topics
    ActsAsTaggableOn::Tag.joins(:taggings)
      .merge(ActsAsTaggableOn::Tagging.where(taggable: past_guests))
      .select('count(*) as count_id, tags.name')
      .where('taggings.context = ?', :topics)
      .group(:id).order('count_id desc')
  end

  def most_promotions
    ActsAsTaggableOn::Tag.joins(:taggings).merge(ActsAsTaggableOn::Tagging.where(taggable: past_guests))
      .select('count(*) as count_id, tags.name')
      .where('taggings.context = ?', :promotions)
      .group(:id).order('count_id desc')
  end

  def most_expertises
    ActsAsTaggableOn::Tag.joins(:taggings).merge(ActsAsTaggableOn::Tagging.where(taggable: past_guests))
      .select('count(*) as count_id, tags.name')
      .where('taggings.context = ?', :expertises)
      .group(:id).order('count_id desc')
  end

  def past_guests
    User.joins(guest_invites: :interview).merge(interviews)
  end

  def social_sites
    ass_ids = account_social_sites.pluck('social_site_id')
    SocialSite.where(id: ass_ids)
  end

  def public_sites
    aps_ids = account_public_sites.pluck('public_site_id')
    PublicSite.where(id: aps_ids)
  end

  def social_url(social_name)
    social_site = SocialSite.where(name: social_name).first
    account_social_site = account_social_sites.where(social_site: social_site).first
    account_social_site.nil? ? '' : account_social_site.url
  end

  def public_url(public_site_name)
    public_site = PublicSite.where(name: social_name).first
    account_public_site = account_public_sites.where(public_site: public_site).first
    account_public_site.nil? ? '' : account_public_site.url
  end

  ############# ElasticSearch #################
  def email
    admin.email
  end

  def total_interviews
    interviews.count
  end

  def wav_downloadable?
    wav_only?
  end

  def mp3_downloadable?
    mp3_only?
  end

  def self.video_resolution_options
    [['Standard Definition Video', 'standard_definition'],
     ['720p HD Video', 'resolution_720p'],
     ['1080p HD Video', 'resolution_1080p']]
  end

  def self.audio_visual_download_options_array
    [['Video and Audio', 'video_and_audio'],
     ['Audio Only', 'audio_only']]
  end

  def self.audio_download_format_options
    [
      ['WAV Only', 'wav_only'],
      ['MP3 Only @ 320kbps bitrate', 'mp3_only']
      # ['WAV and MP3', 'wav_and_mp3']
    ]
  end

  # def outstanding_orders
  #   orders.where.not(aasm_state: ["canceled", "completed"]).count
  # end

  # def new_order?
  #   return false if subscription.nil?
  #   return false unless subscription.ok?
  #   outstanding_orders < max_units
  # end

  # def new_order_reason
  #   return "Your account has no subscription." if subscription.nil?
  #   return "Your subscription is not in good standing." unless subscription.ok?
  #   return "You have reached your current number of outstanding units." if outstanding_orders >= max_units
  #   nil
  # end

private

  def handle_logo_removal
    if remove_logo
      logo.purge if !logo.nil?
    end
  end

end
