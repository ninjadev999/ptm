# frozen_string_literal: true

class InterviewsMailer < ApplicationMailer

  def invite_participant(invite)
    @invite = invite
    @interview = invite.interview.decorate
    mail(to: invite.email, subject: "Interview invitation for #{@interview.account.name} - PTM1")
  end

  def confirmed(invite)
    @invite = invite
    @interview = invite.interview.decorate
    mail(to: @interview.user.email, subject: "#{invite.name} has confirmed your interview request - PTM2")
  end

  def declined(invite)
    @invite = invite
    @interview = invite.interview.decorate
    mail(to: @interview.user.email, subject: "#{invite.name} has declined your interview request - PTM3")
  end

  def apply(invite)
    @invite = invite
    @interview = invite.interview.decorate
    @message = "#{invite.name} has applied your interview."
    @admin = @interview.account.admin
    mail(to: @admin.email, subject: "#{@invite.name} has applied your interview request")
  end
end
