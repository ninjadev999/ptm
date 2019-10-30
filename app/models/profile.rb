# == Schema Information
#
# Table name: profiles
#
#  id               :bigint(8)        not null, primary key
#  bio              :text
#  primary_industry :string
#  user_id          :bigint(8)
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Profile < ApplicationRecord
	belongs_to :user
  has_many :profile_social_sites, inverse_of: :profile, dependent: :destroy
  accepts_nested_attributes_for :profile_social_sites, reject_if: :all_blank, allow_destroy: true

  has_one_attached :photo
  has_one_attached :audio_recording

  validates :photo, file_size: { less_than_or_equal_to: 2.megabytes }, file_content_type: { allow: ['image/jpeg', 'image/png'] }, if: -> { photo.attached? }
  validates :audio_recording, file_size: { less_than_or_equal_to: 5.megabytes }, file_content_type: { allow: ['audio/mpeg', 'audio/mp4', 'audio/ogg', 'audio/vnd.wav'] }, if: -> { audio_recording.attached? }
  
  # validates_presence_of :primary_industry

  ratyrate_rater
  ratyrate_rateable 'entertainment', 'knowledge', 'content'

  def social_sites
    ass_ids = profile_social_sites.pluck('social_site_id')
    SocialSite.where(id: ass_ids)
  end

  def social_url(social_name)
    social_site = SocialSite.where(name: social_name).first
    profile_social_site = profile_social_sites.where(social_site: social_site).first
    profile_social_site.nil? ? '' : profile_social_site.url
  end
end
