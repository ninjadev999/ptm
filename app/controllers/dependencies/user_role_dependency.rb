class ApplicationController
  CURRENT_USER_ROLE_KEY = :current_user_role

  helper_method :current_user_role
  def current_user_role
    @current_user_role ||= session[CURRENT_USER_ROLE_KEY]&.to_sym
    @current_user_role ||= :host if current_user.host?
    @current_user_role ||= :guest if current_user.guest?
    @current_user_role
  end

  def set_user_role(role)
    session[CURRENT_USER_ROLE_KEY] = role
  end

  helper_method :host?
  def host?
    current_user_role == :host
  end

  helper_method :guest?
  def guest?
    current_user_role == :guest
  end
end
