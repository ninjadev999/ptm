# frozen_string_literal: true

class StripeEvent
private

  def customer_source_deleted
    user = User.find_by_stripe_credit_card_id(params["data"]["object"]["id"])
    user.reset_credit_card!
  end

  def customer_source_created
  end

  def customer_updated
    User.update_from_stripe(params["data"]["object"]["id"])
  end

  def customer_deleted
    customer_updated
  end

  def customer_created
    customer_updated
  end

  def customer_discount_created
  end

  def customer_discount_updated
  end

  def customer_discount_deleted
  end
end
