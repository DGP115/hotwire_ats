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

  def process
    email = build_email
    email.body = mail.parts.present? ? mail.parts[0].body.decoded : mail.decoded
    email.save
  end

  private

  def set_applicant
    @applicant = Applicant.find_by(email: mail.from)
  end

  def set_user
    recipient = mail.recipients.find { |r| ALIASED_USER.match?(r) }
    @user = User.find_by(email_alias: recipient[ALIASED_USER, 1])
  end
end
