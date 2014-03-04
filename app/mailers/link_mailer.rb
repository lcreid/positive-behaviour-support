class LinkMailer < ActionMailer::Base
  default from: "no-reply@cleanroutines.com"

  def invitation_email(invitation)
  	@invitation = invitation
  	mail(to: @invitation.e_mail, subject: "Invitation to connect on cleanroutines.com")
  end
end
