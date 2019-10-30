# frozen_string_literal: true

class AccessToken
  def self.create(room, user)
    grant = Twilio::JWT::AccessToken::VideoGrant.new
    grant.room = room.unique_name
    token = Twilio::JWT::AccessToken.new(Rails.application.twilio_client.account_sid, "SK340d439f5b0e6ba9b8c50105536a106d", "LDTW1kxlFNXAT3g8OYez47fnet4P3drm",
                                         [],
                                         identity: user.try(:id),
                                         )
    token.add_grant grant
    token
  end
end
