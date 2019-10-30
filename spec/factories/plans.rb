# frozen_string_literal: true
# == Schema Information
#
# Table name: plans
#
#  id                :bigint(8)        not null, primary key
#  amount_in_cents   :integer
#  interval          :string
#  interval_count    :integer
#  nickname          :string
#  position          :integer          default("disabled"), not null
#  trial_period_days :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  stripe_plan_id    :string
#
# Indexes
#
#  index_plans_on_stripe_plan_id  (stripe_plan_id)
#

FactoryBot.define do
  factory :plan do
    nickname "Cool name"
  end
end
