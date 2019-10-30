# frozen_string_literal: true

class StripeEvent < ApplicationRecord
private

  # This should not be the case - subscriptions are created only from the system
  def customer_subscription_created
    Subscription.create_from_stripe(params["data"]["object"]["id"], params["data"]["object"])
  end

  def customer_subscription_updated
    Subscription.update_from_stripe(params["data"]["object"]["id"], params["data"]["object"])
  end

  def customer_subscription_trial_will_end
    customer_subscription_updated
  end

  def customer_subscription_deleted
    Subscription.find(params["data"]["object"]["id"])&.destroy!
  end
end
