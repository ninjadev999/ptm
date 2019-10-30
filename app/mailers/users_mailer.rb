# frozen_string_literal: true

class UsersMailer < ApplicationMailer
  def welcome(user_id)
    @user = User.find(user_id)
    mail(to: @user.email, subject: "Welcome to PassTheMicrophone! - PTM6")
  end

  def trial_expire(user_id, message)
    @user = User.find(user_id)
    @message = message
    mail(to: @user.email, subject: "Free Trial Expiration! - PTM6")
  end
end
