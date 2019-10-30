class PreRegisterController < BaseController
	skip_before_action :authenticate_user!
	
	def choose_type
	end
end