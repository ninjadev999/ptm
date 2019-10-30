module AccountsHelper

  def all_accounts
    @all_accounts = AccountDecorator.decorate_collection(current_user.accounts.all)
  end

end