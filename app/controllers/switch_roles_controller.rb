class SwitchRolesController < BaseController
	def create
		if guest?
			set_user_role(:host)
			redirect_to current_account.present? ? account_path(current_account) : new_account_path
		else
			set_user_role(:guest)
			redirect_to my_profile_path
		end
	end
end
