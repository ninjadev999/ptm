class GuestRoutes
  def self.session(request)
    request.session
  end

  def self.matches?(request)
    return true if session(request)[:current_user_role]&.to_sym == :guest
    return true if session(request)[:current_user_role]&.to_sym == nil && !request.env['warden'].user(:user)&.host? && request.env['warden'].user(:user)&.guest?
    false
  end
end

class HostRoutes
  def self.session(request)
    request.session
  end

  def self.matches?(request)
    return true if session(request)[:current_user_role]&.to_sym == :host
    return true if session(request)[:current_user_role]&.to_sym == nil && request.env['warden'].user(:user)&.host?
    false
  end
end
