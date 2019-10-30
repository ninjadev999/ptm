
class TwilioComposer

  def initialize(interview)
    @interview = interview
  end

  def create_composition
    composition = Rails.application.twilio_client.video.compositions.create(
      room_sid: room_sid,
      audio_sources: audio_sources,
      status_callback: "https://#{Rails.application.twilio_callback_host}/twilio/events",
      format: 'mp4')
    puts "\n\nTwilio composition:\n#{composition.inspect}\n\n"
  end

  def room_sid
    recording = @interview.recordings.first
    return nil unless recording
    recording.twilio_data["RoomSid"]
  end

  def audio_sources
    recordings = @interview.recordings.select { |r| r.kind == 'Audio' }
    recordings.collect { |r| r.twilio_data['RecordingSid'] }
  end

end
