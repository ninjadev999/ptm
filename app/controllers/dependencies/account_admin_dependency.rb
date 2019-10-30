# frozen_string_literal: true

class AccountNotFound < StandardError; end
class BaseController
  CURRENT_ACCOUNT_SESSION_KEY = :current_account_id

  rescue_from AccountNotFound do
    redirect_to "/accounts", notice: "Select an account"
  end

  def set_current_account(account_id)
    session[CURRENT_ACCOUNT_SESSION_KEY] = account_id
  end

  helper_method :current_account
  def current_account
    @current_account ||= current_user.accounts.find_by(id: session[CURRENT_ACCOUNT_SESSION_KEY]) if session[CURRENT_ACCOUNT_SESSION_KEY]
    @current_account ||= current_user.default_account
  end

  def ensure_account_admin!
    raise AccountNotFound if current_account.nil?
    current_account_admin?
  end

  helper_method :current_account_admin?
  def current_account_admin?
    return false if current_account.nil?
    current_account.admin_id == current_user.id
  end
end
