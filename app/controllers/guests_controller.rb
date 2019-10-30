class GuestsController < BaseController
	skip_before_action :authenticate_user!
	before_action :load_guest, only: :show

	def index
	end

	def show
		if @guest.nil?
			redirect_to interviews_path
		end
		render layout: user_signed_in? ? 'app' : 'site'
	end

	private

		def authorize
			# TODO: generate safe url for guest and share with hosts
		end

		def load_guest
			@guest = User.find(params[:id])
		end
end