# frozen_string_literal: true

# == Schema Information
#
# Table name: credit_cards
#
#  id             :bigint(8)        not null, primary key
#  exp_mo         :integer
#  exp_year       :integer
#  kind           :string
#  last_4         :string
#  owner_type     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#  stripe_card_id :string
#
# Indexes
#
#  index_credit_cards_on_owner_id_and_owner_type  (owner_id,owner_type)
#  index_credit_cards_on_stripe_card_id           (stripe_card_id)
#


require "rails_helper"

RSpec.describe CreditCard, type: :model do
  context "with a valid token" do
    it "is created" do
      user = build_stubbed(:user)
      account = create(:account, admin: user)
      token = StripeMock.generate_card_token
      card = CreditCard.new(token: token, owner: account)
      expect(card.valid?).to be_truthy
      card.save
      expect(card.last_4).to eq("4242")
      expect(card.exp_mo).to eq(4)
      expect(card.exp_year).to eq(2016)
      expect(card.owner).to eq(account)
    end
  end
end
