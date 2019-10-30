# frozen_string_literal: true

class TwilioEventsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "events"
  end
end
