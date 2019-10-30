# frozen_string_literal: true

class EasypostController < BaseController
  skip_before_action :authenticate_user!

  def receive
    puts "I have received an event #{params['description']}"
    mthd = "ep_#{params["description"].gsub(".", "_")}"
    if respond_to?(mthd)
      send(mthd)
    end
  end

private

  def ep_tracker_updated
  end
end
