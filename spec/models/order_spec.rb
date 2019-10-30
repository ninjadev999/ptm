# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id                :bigint(8)        not null, primary key
#  aasm_state        :string
#  canceled_at       :datetime
#  company           :string
#  email             :string
#  interview_at      :date
#  name              :string
#  token             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :integer
#  address_id        :integer
#  credit_card_id    :integer
#  interviewee_id    :integer
#  return_label_id   :integer
#  shipping_label_id :integer
#  unit_id           :integer
#  user_id           :integer
#
# Indexes
#
#  index_orders_on_aasm_state         (aasm_state)
#  index_orders_on_account_id         (account_id)
#  index_orders_on_address_id         (address_id)
#  index_orders_on_email              (email)
#  index_orders_on_interviewee_id     (interviewee_id)
#  index_orders_on_return_label_id    (return_label_id)
#  index_orders_on_shipping_label_id  (shipping_label_id)
#  index_orders_on_token              (token)
#  index_orders_on_unit_id            (unit_id)
#  index_orders_on_user_id            (user_id)
#


require "rails_helper"

describe Order, type: :model do
  context "is valid" do
    it "is valid" do
      account = build_stubbed(:account)
      user = build_stubbed(:user)
      address = build_stubbed(:address)
      order = Order.new(user: user, address: address, account: account, interview_at: Date.today.to_s)
      expect(order.valid?).to be_truthy
      expect(order.save).to be_truthy
      expect(order.aasm_state).to eq("pending")
      order.finalize = "1"
      expect(order.aasm_state).to eq("confirmed")
    end
  end
end
