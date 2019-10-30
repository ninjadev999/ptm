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


FactoryBot.define do
  factory :credit_card do
    association :owner, factory: :account
    token { StripeMock.generate_card_token }
    trait :visa do
      token { StripeMock.generate_card_token }
    end
  end
end
