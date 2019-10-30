# frozen_string_literal: true

class BaseController
  def ensure_account_admin!
    raise AccountNotFound if current_account.nil?
    current_account.admin_id == current_user.id
  end

  def account_admin?
    raise AccountNotFound if current_account.nil?
    current_account.admin_id == current_user.id
  end

  def authorize_account!
    if current_account.nil?
      redirect_to "/accounts", notice: "Select an account"
    end
  end
end
