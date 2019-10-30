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

class Subscription < ApplicationRecord
  # belongs_to :account
  belongs_to :user
  belongs_to :plan

  before_destroy :cancel_stripe_subscription!

  validates :stripe_subscription_id, presence: true, uniqueness: true, on: :create
  validate :unique_plan_for_user_type
  before_validation :create_stripe_subscription!, on: :create
  after_create :create_pro

  delegate :basic?, :pro?, :host_monthly?, :host_yearly?, to: :plan, allow_nil: true

  def self.host
    joins(:plan).merge(Plan.host)
  end

  def self.guest
    joins(:plan).merge(Plan.guest)
  end

  def as_stripe_subscription
    @as_stripe_subscription ||= Stripe::Subscription.retrieve(stripe_subscription_id)
  end

  def ok?
    true
  end

  private

    def create_stripe_subscription!
      begin
        stripe_record = Stripe::Subscription.create(
          customer: user.stripe_customer_id,
          items: [
            {
              plan: plan.stripe_plan_id,
            },
          ]
        )
        self.stripe_subscription_id = stripe_record.id
        [:status, :trial_start, :trial_end, :current_period_end, :canceled_at].each do |attr|
          self[attr] = stripe_record[attr]
        end
      rescue Stripe::InvalidRequestError => e
        return if Rails.env.test?
        self.errors.add(:base, e.message)
        throw(:abort)
      rescue Stripe::StripeError => e
        return if Rails.env.test?
        self.errors.add(:base, e.message)
        throw(:abort)
      end
    end

    def cancel_stripe_subscription!
      as_stripe_subscription.delete if stripe_subscription_id.present?
    rescue Stripe::InvalidRequestError => e
      true
    end

    def unique_plan_for_user_type
      return true if plan.guest? && user.subscriptions.guest.where.not(id: id).blank?
      return true if plan.host? && user.subscriptions.host.where.not(id: id).blank?
      self.errors.add(:base, 'There already exist subscription for this user type')
      false
    end

    def create_pro
      if plan.host?
        user.guest_subscription&.destroy!
        guest_subscription = Subscription.new(user: user, plan: Plan.pro_plan)
        guest_subscription.save(validate: false)
      end
    end
end
