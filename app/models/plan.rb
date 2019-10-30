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

require 'money'
class Plan < ApplicationRecord

  enum position: [:disabled, :basic, :pro, :marketing_pro, :marketing_pro_plus, :host_monthly, :host_yearly]

  def self.guest
    where(position: [:basic, :pro, :marketing_pro, :marketing_pro_plus])
  end

  def self.host
    where(position: [:host_monthly, :host_yearly])
  end

  def self.basic_plan
    Plan.basic.last
  end

  def self.pro_plan
    Plan.pro.last
  end

  def self.host_monthly_plan
    Plan.host_monthly.last
  end

  def self.host_yearly_plan
    Plan.host_yearly.last
  end

  def guest?
    position.to_sym.in? [:basic, :pro, :marketing_pro, :marketing_pro_plus]
  end

  def host?
    position.to_sym.in? [:host_monthly, :host_yearly]
  end

  def amount_str
    Money.new(amount_in_cents, "USD").format
  end

  def self.create_from_stripe(stripe_id)
    resource = Stripe::Plan.retrieve(stripe_id)
    record = Plan.find_or_initialize_by(stripe_plan_id: resource.id)
    record.assign_attributes_from_stripe(resource)
    record.save!
  end

  def self.update_from_stripe(stripe_id)
    create_from_stripe(stripe_id)
  end

  def assign_attributes_from_stripe(stripe_attributes)
    self.class.columns_hash.keys.except("id", "created_at", "updated_at").each do |k|
      self[k] = stripe_attributes[k] if stripe_attributes[k]
    end
    self.amount_in_cents = stripe_attributes.amount
  end

end
