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

FactoryBot.define do
  factory :account do
    name "Cool name"
    max_units 1
    association :admin, factory: :user
  end
end
