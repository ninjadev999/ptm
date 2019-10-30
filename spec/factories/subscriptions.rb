# frozen_string_literal: true
# == Schema Information
#
# Table name: subscriptions
#
#  id                     :bigint(8)        not null, primary key
#  canceled_at            :datetime
#  current_period_end     :datetime
#  status                 :string
#  trial_end              :datetime
#  trial_start            :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :integer
#  plan_id                :integer
#  stripe_subscription_id :string
#  user_id                :bigint(8)
#
# Indexes
#
#  index_subscriptions_on_account_id              (account_id)
#  index_subscriptions_on_plan_id                 (plan_id)
#  index_subscriptions_on_status                  (status)
#  index_subscriptions_on_stripe_subscription_id  (stripe_subscription_id)
#  index_subscriptions_on_user_id                 (user_id)
#

FactoryBot.define do
  factory :subscription do
    status "Cool name"
    association :account, factory: :account
    association :plan, factory: :plan
    stripe_subscription_id "12345"
  end
end
