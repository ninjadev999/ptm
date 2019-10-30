class InterviewPolicy < ApplicationPolicy
	def apply?
		return true if record.posting? && user.guest_subscription.present?
    return true if record.guest_solicited? && user.host_subscription.present?
    false
  end
  
  def search?
    false
  end
end
