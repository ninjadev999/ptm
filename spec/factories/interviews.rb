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

FactoryBot.define do
  factory :interview do
    association :user, factory: :user
    association :account, factory: :account
    association :topic
    name "Super Fun Podcast Show"
    code "aaaa"
    starts_at 5.days.from_now
    twilio_sid '123456789098776'
  end
end
