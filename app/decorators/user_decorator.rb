class UserDecorator < Draper::Decorator
  delegate_all

  def full_name
    [first_name, last_name].join(' ')
  end

  def initials
  	[first_name&.first, last_name&.first].join('')
  end

end
