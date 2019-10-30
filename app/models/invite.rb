# == Schema Information
#
# Table name: invites
#
#  id                  :bigint(8)        not null, primary key
#  address_line1       :string
#  address_line2       :string
#  city                :string
#  code                :string
#  confirmation_status :string           default("invited")
#  email               :string
#  name                :string
#  ready_at            :datetime
#  state               :string
#  status              :integer          default("invited")
#  zip_code            :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :integer
#  guest_id            :integer
#  interview_id        :integer
#
# Indexes
#
#  index_invites_on_interview_id  (interview_id)
#

# TODO: rename this model to members
class Invite < ApplicationRecord

  enum status: { applied: 1, application_declined: -1, invited: 10, declined: 5, confirmed: 15, onboarded: 20 }

  belongs_to :interview
  belongs_to :account, optional: true
  belongs_to :guest, class_name: 'User', optional: true

  has_many :recordings

  validates_presence_of :email, :name, :code
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_uniqueness_of :code

  before_validation :set_code
  after_create :set_guest_by_email, if: :invited?
  after_create :conditionally_send_mailer, if: :invited?
  validate :can_invite_interview?, on: :create, if: :interview_host_owned?
  validate :exclusive_account_guest_reference

  scope :active, -> { where.not(status: :declined) }
  scope :except_applications, -> { where.not(status: [:applied, :application_declined]) }
  scope :applications, -> { where(status: [:applied, :application_declined]) }
  scope :active_invites, -> { except_applications.active }

  delegate :host_owned?, :guest_solicited?, to: :interview, prefix: true

  def set_guest_by_email
    if self.guest.nil?
      guest = User.where(email: self.email).first
      self.guest_id = guest&.id
      save(validate: false)
    end
  end

  # Only send invites upon creation if the interview is not incomplete (e.g. paid for)
  def conditionally_send_mailer
    send_invite unless interview.incomplete?
  end

  def has_region_info?
    !city.blank? || !state.blank? || !zip_code.blank?
  end

  def send_invite
    InterviewsMailer.invite_participant(self).deliver_later
  end

  def left_blank?
    [:name, :email, :address_line1, :city, :state, :zip_code].each do |an_attr|
      return false if !attributes[an_attr.to_s].blank?
    end
    true
  end

  def confirm!
    confirmed!
    interview.assign_account(account) if interview.guest_solicited?
    InterviewsMailer.confirmed(self).deliver_later
  end

  def decline!
    declined!
    InterviewsMailer.declined(self).deliver_later
  end

  def ready!
    self.ready_at = DateTime.now
    save(validate: false)
  end

  def ready?
    self.ready_at ? (self.ready_at > 3.minutes.ago) : false
  end

private

  def set_code
    self.code ||= Rails.configuration.uuid_characters.split("").sample(10).join("")
  end

  # TODO: determine if we should limit invitation or limit confirmation
  def can_invite_interview?
    # errors.add(:base, 'Interview has no seat available') unless interview.new_seat_available?
  end

  def exclusive_account_guest_reference
    # NOTICE: account_id should not be present when account invited a guest
    errors.add(:base, "Don't pass account id for host owned interview") unless account_id.present? ^ interview.host_owned?
  end

end
