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


FactoryBot.define do
  factory :address do
    easypost_address_id "1234"
    nickname "Home"
    name "Marc S"
    street1 "4401 Park Glen Road"
    city "Minneapolis"
    state "MN"
    zip "55416"
    country "US"
    user
  end
end
