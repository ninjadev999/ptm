# frozen_string_literal: true

class TwilioCapability
  def self.generate(role)
    # To find TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN visit
    # https://www.twilio.com/user/account
    account_sid     = ENV["TWILIO_ACCOUNT_SID"]
    auth_token      = ENV["TWILIO_AUTH_TOKEN"]
    application_sid = ENV["TWIML_APPLICATION_SID"]
    # binding.pry
    capability = Twilio::JWT::ClientCapability.new(account_sid, auth_token)
    outgoing_scope = Twilio::JWT::ClientCapability::OutgoingClientScope.new(application_sid, role)
    capability.add_scope outgoing_scope

    incoming_scope = Twilio::JWT::ClientCapability::IncomingClientScope.new(role)
    capability.add_scope incoming_scope


    capability.to_s
  end

  def self.generate_for_video_room(room, identity)
    account_sid     = ENV["TWILIO_ACCOUNT_SID"]
    api_key         = ENV["VIDEO_ACCOUNT_KEY"]
    api_secret      = ENV["VIDEO_ACCOUNT_SECRET"]

    grant = Twilio::JWT::AccessToken::VideoGrant.new
    grant.room = room

    token = Twilio::JWT::AccessToken.new(
      account_sid,
      api_key,
      api_secret,
      [grant],
      identity: identity
    )
    # token = Twilio::JWT::AccessToken.new(account_sid, api_key, api_secret, [], identity: identity);

    # Create Video grant for our token


    token.to_jwt
  end
end
