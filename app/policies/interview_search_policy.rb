class InterviewSearchPolicy < Struct.new(:user, :dashboard)
  def show?
  	user.host? || user.guest_subscription.present?
  end
end
