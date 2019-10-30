# frozen_string_literal: true

# == Schema Information
#
# Table name: addresses
#
#  id                  :bigint(8)        not null, primary key
#  city                :string
#  country             :string
#  name                :string
#  nickname            :string
#  phone               :string
#  state               :string
#  street1             :string
#  street2             :string
#  street3             :string
#  zip                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  easypost_address_id :string
#  user_id             :integer
#
# Indexes
#
#  index_addresses_on_easypost_address_id  (easypost_address_id)
#  index_addresses_on_user_id              (user_id)
#


class Address < ApplicationRecord
  belongs_to :user, optional: true
  has_many :orders, inverse_of: :address
  validates_presence_of :easypost_address_id
  before_validation :sync_to_easypost!, on: :create, unless: :synced?

  def to_s
    [name, city.titleize].join(", ")
  end

  def shippable?
    country == "US"
  end

  def synced?
    easypost_address_id.present?
  end

  def as_easypost_address
    @as_easypost_address ||= EasyPost::Address.retrieve(easypost_address_id)
  end

private

  def sync_to_easypost!
    ep = EasyPost::Address.create(
      verify: ["delivery"],
      name: name,
      street1: street1,
      street2: street2,
      city: city,
      state: state,
      zip: zip,
      country: country,
      phone: phone
    )
    if ep.verifications.delivery.success
      self.easypost_address_id = ep.id
      self.street1 = ep.street1
      self.street2 = ep.street2
      self.city = ep.city
      self.state = ep.state
      self.country = ep.country
      self.zip = ep.zip
    else
      ep.verifications.delivery.errors.each do |error|
        if error.field == "address"
          self.errors.add(:street1, "not found.")
          self.errors.add(:city, "not found.")
          self.errors.add(:state, "not found.")
          self.errors.add(:zip, "not found.")
        else
          self.errors.add(error.field, error.message)
        end
      end
    end
  end
end
