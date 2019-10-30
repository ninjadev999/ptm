# frozen_string_literal: true
# == Schema Information
#
# Table name: recordings
#
#  id                  :bigint(8)        not null, primary key
#  duration_in_seconds :integer
#  size_in_bytes       :integer
#  twilio_data         :jsonb
#  twilio_sid          :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  interview_id        :integer
#  user_id             :integer
#
# Indexes
#
#  index_recordings_on_interview_id  (interview_id)
#  index_recordings_on_twilio_sid    (twilio_sid)
#

class Recording < ApplicationRecord
  has_many_attached :medias
  belongs_to :interview
  belongs_to :user, optional: true

  before_destroy :remove_recording
  after_create :associate_with_user

  def kind
    twilio_data["Container"] == "mka" ? "Audio" : "Video"
  end

  def update_from_twilio_data(data)
    self.twilio_data = data
    self.duration_in_seconds = data["Duration"]
    self.size_in_bytes = data["Size"]
    self.save!
  end

  def source_sid
    self.twilio_data["SourceSid"]
  end

  def filename_base
    interview_name_safe = self.interview.name.gsub(/[^0-9a-z ]/i, '')
    date_formatted = self.interview.starts_at.strftime("%m-%d-%Y")
    if !self.user.nil?
      return "#{interview_name_safe} - #{self.user.full_name} (#{date_formatted})"
    else
      return "#{interview_name_safe} (#{date_formatted})"
    end
  end

  private

    def remove_recording
      medias.purge
    end

    def associate_with_user
      track_sid = TrackSid.where(track_sid: self.source_sid).first
      return if track_sid.nil?
      self.user = track_sid.user
      save
    end

end
