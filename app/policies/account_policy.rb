class AccountPolicy < ApplicationPolicy

	def manage_invites?
		record.admin == user
	end
end

