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

class HostInterview < Interview
  belongs_to :account
  has_many :invited_guests, through: :invites, source: :guest
  has_many :applied_guests, through: :applicants, source: :guest

  before_validation :set_free_flag
  validate :creatable?, on: :create
  after_create :set_format_options

  index_name('interviews')
  document_type('_doc')

  def user
    account.admin
  end

  private

    def creatable?
      # TODO: figure out how to prevent users create an incomplete interview later since this validation is only on create
      #       this should be moved to payment_complete!
      errors.add(:base, "No interview available for invite PTM guest") if posting? && !user.posting_available?
      errors.add(:base, "No interview available") if !posting? && !user.single_itv_available?
    end

    def set_free_flag
      self.free = user.free_interview_eligible?
    end
end
