# frozen_string_literal: true
# == Schema Information
#
# Table name: interviews
#
#  id                            :bigint(8)        not null, primary key
#  accepted_at                   :datetime
#  addon_seats                   :integer          default(0)
#  audio_download_formats        :integer          default("wav_only")
#  audio_visual_download_options :integer          default("audio_only")
#  code                          :string
#  completed_at                  :datetime
#  duration_in_seconds           :integer
#  free                          :boolean          default(FALSE)
#  ideal_guest_desc              :text
#  ideal_listener_action         :text
#  max_resolution                :integer          default("resolution_720p")
#  name                          :string
#  needs_hardware                :boolean          default(FALSE)
#  posting                       :boolean          default(FALSE), not null
#  prep_stage                    :integer          default(1)
#  read_ahead                    :text
#  read_ahead_opened_at          :datetime
#  size_in_bytes                 :integer
#  starts_at                     :datetime
#  state                         :integer          default("incomplete")
#  twilio_data                   :jsonb
#  twilio_sid                    :string
#  type                          :string           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  account_id                    :integer
#  category_id                   :integer
#  guest_id                      :integer
#
# Indexes
#
#  index_interviews_on_account_id  (account_id)
#  index_interviews_on_code        (code) UNIQUE
#  index_interviews_on_state       (state)
#  index_interviews_on_twilio_sid  (twilio_sid) UNIQUE
#

class Interview < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  MAX_PARTICIPANTS = 9

  enum state: { incomplete: -1, waiting: 0, prep: 3, live: 5, ended: 10 }
  enum max_resolution: { standard_definition: 0, resolution_720p: 1, resolution_1080p: 2 }
  enum audio_visual_download_options: { video_and_audio: 0, audio_only: 1 }
  enum audio_download_formats: { wav_only: 0, mp3_only: 1 }

  has_one_attached :read_ahead_file
  has_one_attached :auto_transcription

  has_many :recordings, dependent: :destroy
  has_many :compositions

  has_many :members, class_name: 'Invite'
  has_many :invites, -> { except_applications }
  has_many :applicants, -> { applications }, class_name: 'Invite'

  acts_as_taggable_on :topics, :promotions, :expertises

  before_validation :set_code
  validates_uniqueness_of :code
  validates_presence_of :code, :name
  before_create :set_state

  scope :upcoming, -> { purchased.where.not(state: :ended).order(:starts_at) }
  scope :purchased, -> { where.not(state: :incomplete) }
  scope :free, -> { where(free: true) }
  scope :scheduled, -> { purchased.where.not(state: :ended) }
  scope :past, -> { purchased.ended }
  scope :posting, -> { where(posting: true) }
  scope :solicited, -> { where(type: 'SolicitedInterview') }
  scope :hosted, -> { where(type: 'HostInterview') }
  scope :upcoming_for_guest, -> { where("interviews.state >= 0 AND interviews.state <= 5") }

  settings do
    mappings dynamic: 'false' do
      indexes :topic_list, type: :keyword
      indexes :promotion_list, type: :keyword
      indexes :expertise_list, type: :keyword
      indexes :type, type: :keyword
    end
  end

  def self.search_for(*args,&block)
    __elasticsearch__.search(*args, &block)
  end

  def as_json(options={})
    json = super(options)
    json[:type] = type
    json
  end

  def prep_code
    "prep#{self.code}"
  end

  def interview_lifespan
    return 'N/A' if completed_at.blank?
    (completed_at.to_date + 365.days - Date.today).to_i
  end

  def payment_complete!
    waiting!
    send_invites
  end

  def send_invites
    invites.each do |invite|
      invite.send_invite
    end
  end

  def interviewee
    invites.first
  end

  def unique_name
    code
  end

  def formatted_duration
    return nil unless duration_in_seconds
    Time.at(duration_in_seconds).utc.strftime("%H:%M:%S")
  end

  def completed=(val)
    if val == "true" || val.to_s == "1" || val == true
      # as_twilio_room.update(status: 'completed')
      complete!
    end
  end

  def complete!
    touch :completed_at
    ended!
  end

  def price
    price_in_cents / 100.0
  end

  def price_in_cents
    return 0 if self.free
    needs_hardware ? WITH_HARDWARE_COST : REGULAR_COST
  end

  def checkout_description
    if needs_hardware
      'Standard Interview With Remote Studio'
    else
      'Standard Interview (no Remote Studio)'
    end
  end

  def guest_seats
    self.addon_seats + 1
  end

  def purchased_addon_seats!(seat_count)
    self.addon_seats += seat_count
    save(validate: false)
  end

  def new_seat_available?
    guest_seats > invites.active_invites.count
  end

  # @usage for Invite another button on new invite form
  def two_seats_available?
    guest_seats > invites.active_invites.count + 1
  end

  def purchased_posting!
    payment_complete!
  end

  def no_confirmed_guests?
    invites.confirmed.empty?
  end

  def all_confirmed_guests_waiting?
    return false if no_confirmed_guests?
    all_confirmed = true
    invites.confirmed.map { |i| all_confirmed = (all_confirmed && i.ready?)}
    all_confirmed
  end

  def room_params
    {
      unique_name: code,
      record_participants_on_connect: true,
      type: "group-small",
      status_callback: "https://#{Rails.application.twilio_callback_host}/twilio/events"
    }
  end

  def prep_room_params
    {
      unique_name: self.prep_code,
      record_participants_on_connect: false,
      type: "group-small",
      status_callback: "https://#{Rails.application.twilio_callback_host}/twilio/prep_events"
    }
  end

  def video_width
    case max_resolution
    when 'standard_definition'
      640
    when 'resolution_720p'
      1280
    when 'resolution_1080p'
      1920
    else
      1280
    end
  end

  def video_height
    case max_resolution
    when 'standard_definition'
      480
    when 'resolution_720p'
      720
    when 'resolution_1080p'
      1080
    else
      720
    end
  end

  def set_format_options
    self.max_resolution = account.max_resolution
    self.audio_visual_download_options = account.audio_visual_download_options
    self.audio_download_formats = account.audio_download_formats
    save
  end

  def audio_recordings
    recordings.select { |r| r.twilio_data["Container"] == "mka" }
  end

  def video_recordings
    recordings.select { |r| r.twilio_data["Container"] == "mkv" }
  end

  def audio_medias
    all_audio_medias = []
    audio_recordings.each_with_index do |r, index|
      r.medias.each do |media|
        all_audio_medias << media
      end
    end
    all_audio_medias
  end

  def video_medias
    all_video_medias = []
    video_recordings.each_with_index do |r, index|
      r.medias.each do |media|
        all_video_medias << media
      end
    end
    all_video_medias
  end

  def has_read_ahead_info?
    !self.read_ahead.blank? || self.read_ahead_file.attached?
  end

  def self.regular_cost_in_dollars
    (REGULAR_COST / 100.00).round(2)
  end

  def self.with_hardware_cost_in_dollars
    (WITH_HARDWARE_COST / 100.0).round(2)
  end

  def host_owned?
    type == 'HostInterview'
  end

  def guest_solicited?
    type == 'SolicitedInterview'
  end

private

  def set_code
    self.code ||= Rails.configuration.uuid_characters.split("").sample(6).join("")
  end

  def set_state
    self.state = :waiting if posting?
  end

  # Let's add this back in once users can actually add in the hardware option
  # def hardware_option_constraints
  #   return if starts_at.nil?
  #   if needs_hardware && starts_at < 5.days.from_now.beginning_of_day
  #     errors.add(:starts_at, "must be at least 4 days from now if you have selected the Remote Studio hardware option")
  #   end
  # end

end
