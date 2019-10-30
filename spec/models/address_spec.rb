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


require "rails_helper"

describe Address, type: :model do
  describe "methods" do
    let(:address) { create :address }
    describe "to_s" do
      it "returns the name and the titleized city" do
        address.name = "Mark Grandjean"
        address.city = "San Francisco"
        expect(address.to_s).to eq "Mark Grandjean, San Francisco"
      end
    end
    describe "shippable?" do
      it "can ship to the us" do
        expect(address).to be_shippable
      end
      it "can't ship to anywhere else" do
        address.update_attribute(:country, "JP")
        expect(address).to_not be_shippable
      end
    end
  end
end
