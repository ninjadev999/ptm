# frozen_string_literal: true

module Guest
	class InvitesController < Guest::BaseController
		def index
			# @invites = Invite.where(email: current_user.email)
			@invites = current_user.invites.invited
		end
	end
end