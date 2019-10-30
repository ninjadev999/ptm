# frozen_string_literal: true

# == Schema Information
#
# Table name: units
#
#  id         :bigint(8)        not null, primary key
#  make       :string
#  model      :string
#  serial     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#


class Unit < ApplicationRecord
  has_one :order

  def assignable_to?(other_order)
    return true if order.nil?
    other_order == order
  end

  def name
    [make, model, "#{serial}"].join(" ")
  end

  def to_parcel
    EasyPost::Parcel.create(
      width: 15.2,
      length: 18,
      height: 9.5,
      weight: 35.1
    )
  end
end
