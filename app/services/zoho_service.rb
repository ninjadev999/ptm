require 'digest'
require 'uri'

class ZohoService

  def initialize(user)
    @user = user
  end

  def redirect_url
    @redirect_url ||= craft_redirect_url
  end

protected

  def craft_redirect_url
    email = @user.email
    ts = DateTime.now.utc.to_i
    combined = ['signin', email, remoteauthkey, ts].join('')
    apikey = Digest::MD5.hexdigest(combined)
    redirect_params = "?operation=signin&email=#{URI.encode(email)}&ts=#{ts}&apikey=#{apikey}"
    "https://support.passthemicrophone.com/support/RemoteAuth#{redirect_params}"
  end

  def remoteauthkey
    ENV.fetch('ZOHO_REMOTE_AUTH_KEY') { raise("Zoho Rmote Auth Key environment variable not set") }
  end

end