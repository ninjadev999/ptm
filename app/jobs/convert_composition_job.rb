# frozen_string_literal: true

class ConvertCompositionJob < ApplicationJob
  queue_as :default

  def perform(composition_id)
    composition = Composition.find(composition_id)
    interview = composition.interview
    s3 = Aws::S3::Client.new

    composition_file_name = "composition#{composition.id}.mp4"

    composition_sid = composition.twilio_data["CompositionSid"]
    uri = "https://video.twilio.com/v1/Compositions/#{composition_sid}/Media?Ttl=6000"

    response = Rails.application.twilio_client.request("video.twilio.com", 443, "GET", uri)
    media_location = response.body["redirect_to"]

    IO.copy_stream(open(media_location), composition_file_name)

    # WAV conversion
    if interview.wav_only?
      output_file_name = "#{composition.filename_base}.wav"

      `ffmpeg -y -i "#{composition_file_name}" "#{output_file_name}"`

      file = File.open("./#{output_file_name}", "rb")
      composition.wav.attach(io: file, filename: output_file_name, content_type: "audio/wav")
      file.close
    end

    # MP3 conversion
    if interview.mp3_only?
      output_file_name = "#{composition.filename_base}.mp3"

      `ffmpeg -y -i "#{composition_file_name}" -codec:a libmp3lame -b:a 320k "#{output_file_name}"`

      file = File.open("./#{output_file_name}", "rb")
      composition.mp3.attach(io: file, filename: output_file_name, content_type: "audio/mp3")
      file.close
    end

  end

end
