class PodcastInviteMailer < ApplicationMailer

  def sent_invite(invite)
    @invite = invite
    mail(to: invite.email, subject: "Admin invite for #{@invite.account.name} ")
  end

  def confirmed(invite)
    @invite = invite
    mail(to: @invite.email, subject: "#{invite.name} has confirmed your admin request")
  end

  def declined(invite)
    @invite = invite
    mail(to: @invite.email, subject: "#{invite.name} has declined your admin request")
  end

end
