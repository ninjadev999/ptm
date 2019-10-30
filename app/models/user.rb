# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  bundle_itv_purchased   :integer          default(0), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  guest                  :boolean          default(FALSE), not null
#  host                   :boolean          default(TRUE), not null
#  last_name              :string
#  provider               :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  single_itv_purchased   :integer          default(0)
#  uid                    :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  stripe_customer_id     :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_stripe_customer_id    (stripe_customer_id)
#  index_users_on_username              (username) UNIQUE
#

class User < ApplicationRecord
  include StripeCustomerable
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  attribute :current_password

  # Host
  has_many :account_users
  has_many :accounts, through: :account_users, dependent: :destroy
  has_many :admin_accounts, foreign_key: :admin_id, class_name: 'Account', dependent: :destroy
  
  has_many :host_admin_interviews, through: :admin_accounts, source: :host_interviews
  has_many :host_interviews, through: :accounts, class_name: 'HostInterview'
  # has_many :host_solicited_interviews, through: :accounts, class_name: 'SolicitedInterview'
  has_many :addresses, dependent: :destroy

  # Stripe integration
  has_many :credit_cards, as: :owner, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :orders
  has_many :invoices

  # Guset - Invites, applicants
  has_many :guest_members, foreign_key: :guest_id, class_name: 'Invite'
  has_many :guest_invites, -> { except_applications }, foreign_key: :guest_id, class_name: 'Invite'
  has_many :guest_applicants, -> { applications }, foreign_key: :guest_id, class_name: 'Invite'
  has_many :guest_interviews, through: :guest_invites, source: :interview, class_name: 'HostInterview'
  has_many :guest_solicited_interviews, foreign_key: :guest_id, class_name: 'SolicitedInterview', dependent: :destroy

  # Host - PodcastInvite
  has_many :host_members, foreign_key: :host_id, class_name: 'PodcastInvite'
  has_many :host_invites, foreign_key: :user_id, class_name: 'PodcastInvite'

  has_many :host_accounts, through: :host_invites,  source: :account#, class_name: 'PodcastInvite'


  # TODO: move this to profile
  acts_as_taggable_on :topics, :promotions, :expertises

  # Guest
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile
  delegate :primary_industry, to: :profile, allow_nil: true

  # ratyrate_rater
  # ratyrate_rateable 'entertainment', 'knowledge', 'content'

  after_create :assign_invites
  after_create :welcome_email

  settings do
    mappings dynamic: 'false' do
      indexes :topic_list, type: :keyword
      indexes :promotion_list, type: :keyword
      indexes :expertise_list, type: :keyword
      indexes :primary_industry, type: :keyword
      indexes :guest
      indexes :host
      indexes :subscription_level
    end
  end

  scope :guest, -> { where(guest: true) }
  scope :host, -> { where(host: true) }

  validate :role_present?
  validates :topic_list, length: { maximum: 10, message: 'You can add a maximum of 10 topics' }
  validates :promotion_list, length: { maximum: 10, message: 'You can add a maximum of 10 promotions' }
  validates :expertise_list, length: { maximum: 10, message: 'You can add a maximum of 3 expertises' }

  def as_json(options={})
    json = super(options)
    json[:primary_industry] = primary_industry
    json[:subscription_level] = subscription_level
    json
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def host_subscription
    subscriptions.host.first
  end

  def guest_subscription
    subscriptions.guest.first
  end

  def subscription_level
    guest_subscription&.plan&.position
  end

  delegate :basic?, :pro?, to: :guest_subscription, allow_nil: true

  def basic_or_pro?
    basic? || pro?
  end

  def default_account
    accounts.first
  end

  def card_on_file?
    credit_cards.any?
  end

  def total_interviews_count
    total = 0
    accounts.map { |a| total += a.interviews.count }
    total
  end

  def free_interview_eligible?
    free_interviews_count < NUM_FREE_INTERVIEWS
  end

  def free_interviews_count
    host_admin_interviews.free.count
  end

  def single_itv_available?
    free_interview_eligible? || host_subscription || single_itv_remaining.positive?
  end

  def posting_available?
    free_interview_eligible? || host_subscription || bundle_itv_remaining.positive?
  end

  def bundle_itv_remaining
    [bundle_itv_purchased - host_admin_interviews.purchased.posting.count, single_itv_remaining].min
  end

  def single_itv_remaining
    single_itv_purchased + bundle_itv_purchased - host_admin_interviews.purchased.where(free: false).count
  end

  def add_bundle!(bundle)
    self.single_itv_purchased += bundle.number_of_interviews if bundle.single?
    self.bundle_itv_purchased += bundle.number_of_interviews if bundle.pack?
    save(validate: false)
  end

  def assign_invites
    Invite.where(email: email).update_all(guest_id: id) if guest?
  end

  def as_json(options={})
    json = super(options)
    json[:primary_industry] = primary_industry
    json[:subscription_level] = subscription_level
    json
  end

  ###### ElasticSearch helpers #######
  def self.search_for(*args,&block)
    __elasticsearch__.search(*args, &block)
  end
  ####################################

  def self.create_with_omniauth(auth, guest_signup)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      user.email = auth['info']['email']
      user.first_name = auth['info']['first_name']
      user.last_name = auth['info']['last_name']
      user.profile = Profile.new
      user.password = Devise.friendly_token[0,20]
      user.guest = guest_signup
      user.host = !guest_signup
    end
  end

  def send_trial_expire(message)
    UsersMailer.trial_expire(self.id, message).deliver_later
  end

  private

    def welcome_email
      UsersMailer.welcome(id).deliver_later
    end

    def role_present?
      errors << 'Guest or Host should be specified.' unless guest? or host?
    end
end
