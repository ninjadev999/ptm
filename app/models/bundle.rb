# frozen_string_literal: true

# == Schema Information
#
# Table name: bundles
#
#  id                   :bigint(8)        not null, primary key
#  name                 :string
#  number_of_interviews :integer
#  price_in_cents       :integer
#  status               :integer          default("inactive")
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#


class Bundle < ApplicationRecord

  enum status: { inactive: 0, active: 1 }

  scope :count_ascending, -> { order("number_of_interviews ASC") }
  scope :count_descending, -> { order("number_of_interviews DESC") }

  def single?
    1 == number_of_interviews
  end

  def pack?
    number_of_interviews > 1
  end

  def price_per_interview
    (price_in_cents.to_f / number_of_interviews.to_f).round(2)
  end

  def price_per_interview_in_dollars
    Bundle.to_dollars(price_per_interview)
  end

  def price_in_dollars
    Bundle.to_dollars(price_in_cents)
  end

  def self.single
    active.find_by(number_of_interviews: 1)
  end

  def self.single_addon_seat_in_dollars
    Bundle.to_dollars(ADDON_SEAT_PRICE)
  end

  def self.two_addon_seats_in_dollars
    Bundle.to_dollars(ADDON_SEAT_PRICE * 2)
  end

  def self.price_for_addon_seats_in_dollars(addon_seats_count = 0)
    Bundle.to_dollars(ADDON_SEAT_PRICE * addon_seats_count)
  end

  def self.to_dollars(amount_in_cents = 0)
    (amount_in_cents / 100.0).round(2)
  end

end
