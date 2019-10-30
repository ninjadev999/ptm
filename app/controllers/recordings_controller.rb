# frozen_string_literal: true

class RecordingsController < BaseController
  def show
    @interview = current_account.interviews.find(params[:interview_id])
    @recording = @interview.recordings.find(params[:id])
    respond_to do |f|
      f.mp3 do
        uri = "https://video.twilio.com/v1/Recordings/#{@recording.twilio_sid}/Media"
        response = Rails.application.twilio_client.request("video.twilio.com", 443, "GET", uri)
        redirect_to response.body["redirect_to"]
      end
    end
  end
end
