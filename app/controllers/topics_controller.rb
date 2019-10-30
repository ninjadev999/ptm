# frozen_string_literal: true

class TopicsController < BaseController

	respond_to :json

  def index
  	render json: Topic.all.to_json
  end
end
