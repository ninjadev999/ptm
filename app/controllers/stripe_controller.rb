# frozen_string_literal: true

class StripeController < BaseController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def receive
    StripeEvent.execute(params)
    head :ok
  end
end
