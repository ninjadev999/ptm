# frozen_string_literal: true

class ConvertRecordingJob < ApplicationJob
  queue_as :default

  def perform(recording_id)
    recording = Recording.find(recording_id)
    interview = recording.interview
    s3 = Aws::S3::Client.new

    raw_file_name = "#{recording.twilio_data["RecordingSid"]}.mka"

    output_wav_file_name = "#{recording.filename_base}.wav"
    output_mp3_file_name = "#{recording.filename_base}.mp3"

    uri = "https://video.twilio.com/v1/" +
          "Rooms/#{recording.twilio_data["RoomSid"]}/" +
          "Recordings/#{recording.twilio_data["RecordingSid"]}/" +
          "Media"

    response = Rails.application.twilio_client.request("video.twilio.com", 443, "GET", uri)
    media_location = response.body["redirect_to"]

    IO.copy_stream(open(media_location), raw_file_name)

    file = File.open("./#{raw_file_name}", "rb")
    s3.put_object(bucket: "passthemicrophone-raw-recordings", key: raw_file_name, body: file)
    file.close

    # WAV conversion
    if recording.interview.wav_only?

      `ffmpeg -i #{raw_file_name} "#{output_wav_file_name}"`

      file = File.open("./#{output_wav_file_name}", "rb")
      recording.medias.attach(io: file, filename: output_wav_file_name, content_type: "audio/wav")
      file.close
    end

    # MP3 conversion
    if recording.interview.mp3_only?

      `ffmpeg -i #{raw_file_name} -codec:a libmp3lame -b:a 320k "#{output_mp3_file_name}"`

      file = File.open("./#{output_mp3_file_name}", "rb")
      recording.medias.attach(io: file, filename: output_mp3_file_name, content_type: "audio/mp3")
      file.close
    end

  end
end
