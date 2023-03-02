# frozen_string_literal: true

#  app-specific class used to handle emails received by this app

#  When an email is received with a 'to' address that includes 'reply' in the address,
#  the ApplicantReplies mailbox, steps in.

#  The reply string will contain a randomly generated string to identify the user who should
#  receive the reply.  A complete to address might look something like
#  “reply-davidcolby1241@hotwiredats.com”, where 129aad91 is a unique identifier for a user in the
#  database.

#  This mailbox will process the email,
#     - route it to the correct user/applicant combination by extracting information from the
#       inbound mail object, and then
#     - save a new Email record in the database.
class ApplicantRepliesMailbox < ApplicationMailbox
  #  ALIASED_USER is a regex
  ALIASED_USER = /reply-(.+)@hotwiringrails.com/i

  before_processing :set_applicant
  before_processing :set_user

  #  Method 'process' is called automnatically whenever a new email is received.
  #  We build a new Email record and save it in the database, using the decoded method from the
  #  mail gem to extract the body of the inbound email.
  def process
    email = build_email
    email.body = mail.parts.present? ? mail.parts[0].body.decoded : mail.decoded
    email.save
  end

  private

  def set_applicant
    #  Determine the applicant that sent the email.
    #  This is over-simplified in that we assume the applicant emails the app using the email
    #  address they gave when they registered with the app
    @applicant = Applicant.find_by(email: mail.from)
  end

  def set_user
    #  Determine the user that should receive the applicant's email.
    #   1.  Using methods from gem 'mail', extract the recipients from the
    #       email.
    #   2.  Check each recipient email address against the ALIASED_USER regex.
    #   3.  Once a match is found, the matching email address is used to find a user
    #       in the database by their email alias.
    recipient = mail.recipients.find { |r| ALIASED_USER.match?(r) }
    @user = User.find_by(email_alias: recipient[ALIASED_USER, 1])
  end

  def build_email
    Email.new(
      user_id: @user.id,
      applicant_id: @applicant.id,
      subject: mail.subject,
      email_type: 'inbound'
    )
  end
end
