# frozen_string_literal: true

#  app-specific mailer class to send emails to job applicants
class ApplicantMailer < ApplicationMailer
  def contact(email:)
    @email = email
    @applicant = @email.applicant
    @user = @email.user

    mail(
      to: @applicant.email,
      from: @user.email,
      subject: @email.subject
    )
  end
end
