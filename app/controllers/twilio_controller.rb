# frozen_string_literal: true

class TwilioController < BaseController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def receive
    response = Twilio::TwiML::VoiceResponse.new
    response.dial(record: "record-from-answer") do |dial|
      dial.conference(params["conference_room"], record: "record-from-start", status_callback_event: "start end join leave mute hold", status_callback: "http://www.passthemicrophone.com/twilio/events")
    end

    render xml: response.to_xml
  end

  def events
    interview = Interview.find_by_code(params[:RoomName])
    case params[:StatusCallbackEvent]
    when "participant-connected"
      interview.update_attributes(twilio_sid: params[:RoomSid], state: "live")
    when "room-ended"
      interview = Interview.find_by_twilio_sid(params["RoomSid"])
      if interview
        interview.complete!
        composer = TwilioComposer.new(interview)
        composer.create_composition
      end
    when "recording-completed"
      recording = interview.recordings.new(twilio_sid: params["RecordingSid"], twilio_data: params, duration_in_seconds: params["Duration"])
      if recording.save
        if params["Container"] == "mka"
          ConvertRecordingJob.perform_later(recording.id)
        elsif interview.video_and_audio?
          AddVideoRecordingJob.perform_later(recording.id)
        end
      else
        raise ActiveRecord::RecordInvalid, recording
      end
    when 'composition-available'
      interview = Interview.where(twilio_sid: params[:RoomSid]).first
      if interview
        composition = interview.compositions.new(twilio_data: params)
        if composition.save
          ConvertCompositionJob.perform_later(composition.id)
        else
          raise ActiveRecord::RecordInvalid, composition
        end
      end
    end
    ActionCable.server.broadcast "events", event: params
  end

  def prep_events
    # room_name = params[:RoomName]
    # code = room_name.gsub("prep-", '')
    #interview = Interview.find_by_code(code)
    ActionCable.server.broadcast "prep_events", event: params
  end

end
