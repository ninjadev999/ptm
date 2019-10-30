class AccountDecorator < Draper::Decorator
  delegate_all

  def next_interview
  	interviews.upcoming.first
  end

  def previous_interview
  	interviews.past.last
  end

  def initials
  	first_name, last_name = name.to_s.split(' ')
  	[first_name&.first, last_name&.first].join('')
  end
end
