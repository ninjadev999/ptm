# frozen_string_literal: true

# == Schema Information
#
# Table name: compositions
#
#  id           :bigint(8)        not null, primary key
#  twilio_data  :jsonb
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  interview_id :integer
#


class Composition < ApplicationRecord
  has_one_attached :media
  has_one_attached :mp3
  has_one_attached :wav
  belongs_to :interview

  def filename_base
    account_name = interview.account.name
    interview_name_safe = self.interview.name.gsub(/[^0-9a-z ]/i, '')
    date_formatted = self.interview.starts_at.strftime("%m-%d-%Y")
    "#{account_name} - #{interview_name_safe} (#{date_formatted})"
  end

end
