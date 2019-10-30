class InviteDecorator < Draper::Decorator
  delegate_all

  def initials
    first_name, last_name = name.split(' ')
  	[first_name&.first, last_name&.first].join('')
  end

end
