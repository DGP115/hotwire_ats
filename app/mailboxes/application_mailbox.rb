# frozen_string_literal: true

#  app-specific class used to set routing rules for emails received by this app.
#  This rule tells ActionMailbox to route inbound emails with reply in the to address to the
#  ApplicantReplies mailbox where they will be processed and delivered to the appropriate user.
class ApplicationMailbox < ActionMailbox::Base
  routing(/reply/i => :applicant_replies)
end
