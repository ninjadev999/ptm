# frozen_string_literal: true

class AddVideoRecordingJob < ApplicationJob
  queue_as :default

  def perform(recording_id)
    recording = Recording.find(recording_id)
    s3 = Aws::S3::Client.new

    raw_file_name = "#{recording.filename_base}.mkv"

    uri = "https://video.twilio.com/v1/" +
          "Rooms/#{recording.twilio_data["RoomSid"]}/" +
          "Recordings/#{recording.twilio_data["RecordingSid"]}/" +
          "Media"

    response = Rails.application.twilio_client.request("video.twilio.com", 443, "GET", uri)
    media_location = response.body["redirect_to"]

    IO.copy_stream(open(media_location), raw_file_name)

    file = File.open("./#{raw_file_name}", "rb")
    recording.medias.attach(io: file, filename: raw_file_name, content_type: "video/mkv")
    file.close
  end
end
