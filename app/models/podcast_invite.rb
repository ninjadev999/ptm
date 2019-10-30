# == Schema Information
#
# Table name: podcast_invites
#
#  id                  :bigint(8)        not null, primary key
#  city                :string
#  code                :string
#  confirmation_status :string           default("invited")
#  email               :string
#  name                :string
#  state               :string
#  status              :integer          default("invited")
#  zipcode             :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  account_id          :bigint(8)
#  host_id             :integer
#  user_id             :bigint(8)
#
# Indexes
#
#  index_podcast_invites_on_account_id  (account_id)
#  index_podcast_invites_on_user_id     (user_id)
#

class PodcastInvite < ApplicationRecord
  enum status: { invited: 10, declined: 5, confirmed: 15, onboarded: 20 }

  belongs_to :account
  belongs_to :host, optional: true
  belongs_to :user, optional: true

  validates_presence_of :email, :name, :code
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_uniqueness_of :code

  before_validation :set_code
  after_destroy :destroy_account_user

  def confirm!
    confirmed!
    AccountUser.find_or_create_by(user_id: user_id, account_id: account_id) if user_id.present?
    PodcastInviteMailer.confirmed(self).deliver_later
  end

  def decline!
    declined!
    AccountUser.where(user_id: user_id, account_id: account_id).destroy_all
    PodcastInviteMailer.declined(self).deliver_later
  end

  def set_account_user
    if user_id.present? && confirmed?
      AccountUser.find_or_create_by(user_id: user_id, account_id: account_id)
    end
  end

  def send_invite
    PodcastInviteMailer.sent_invite(self).deliver_later
  end

  private

    def set_code
      self.code ||= Rails.configuration.uuid_characters.split("").sample(10).join("")
    end

    def destroy_account_user
      AccountUser.find_by(user_id: user_id, account_id: account_id)&.destroy
    end
end


