# frozen_string_literal: true

module InterviewsHelper

  def no_addon_seats?(interview)
    return true if interview.nil?
    interview.invites.count <= 1
  end

  def one_addon_seat?(interview)
    return false if interview.nil?
    interview.invites.count == 2
  end

  def two_addon_seats?(interview)
    return false if interview.nil?
    interview.invites.count >= 3
  end

  def max_resolution_desc(key)
    map = {}
    Account.video_resolution_options.map { |o| map[o[1]] = o[0]}
    map[key]
  end

  def audiovisual_dolwnload_desc(key)
    map = {}
    Account.audio_visual_download_options_array.map { |o| map[o[1]] = o[0]}
    map[key]
  end

  def audio_download_format(key)
    map = {}
    Account.audio_download_format_options.map { |o| map[o[1]] = o[0]}
    map[key]
  end

  def media_content_type_readable(content_type)
    mapping = {'audio/wav' => 'WAV', 'audio/mp3' => 'MP3',
               'audio/x-wav' => 'WAV', 'audio/mpeg' => 'MP3',
               'video/mkv' => 'Matroska Video',
               'application/x-matroska' => 'Matroska Video'}
    mapping[content_type] || "Other: #{content_type}"
  end

  def css_class_for_invite(invite)
    invite.ready? ? 'ready' : 'not-ready'
  end

  def css_for_all_guests_ready(guest_readiness)
    guest_readiness ? 'all-ready' : 'waiting-on-some'
  end

  def media_download_desc(recording, media)
    recording.user.nil? ? "Recording ##{recording.id}" : "#{recording.user.full_name} (#{media_content_type_readable(media.content_type)})"
  end

  def safe_local_time(_datetime)
    _datetime.present? ? local_time(_datetime) : 'Unscheduled'
  end

end