# frozen_string_literal: true

class PromotionsController < BaseController

	respond_to :json

  def index
  	render json: Promotion.all.to_json
  end
end
