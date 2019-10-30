# frozen_string_literal: true

class StripeEvent
private

  def plan_created
    plan_updated
  end

  def plan_deleted
    Plan.find(params["data"]["object"]["id"]).destroy
  end

  def plan_updated
  	Plan.update_from_stripe(params["data"]["object"]["id"])
  end
end
