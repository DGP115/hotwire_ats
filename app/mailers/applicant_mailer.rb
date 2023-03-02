# frozen_string_literal: true

#  app-specific mailer class to SEND emails to job applicants
class ApplicantMailer < ApplicationMailer
  def contact(email:)
    @email = email
    @applicant = @email.applicant
    @user = @email.user

    #  When an applicant receives an email sent from our application, replies they send should be
    #  sent to an email address that matches the user's email alias so our application can properly
    #  route the inbound email. So, set the "from" portion of the email to the user's alias.

    #  NOTE:  "mail" is a method of the mail gem
    mail(
      to: @applicant.email,
      from: "reply-#{@user.email_alias}@hotwiringrails.com",
      subject: @email.subject
    )
  end
end
