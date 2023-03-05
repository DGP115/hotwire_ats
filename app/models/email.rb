# frozen_string_literal: true

# App email model.  Store emails to applicants in the app for continuity.
class Email < ApplicationRecord
  has_rich_text :body

  belongs_to :applicant
  belongs_to :user

  validates_presence_of :subject

  after_create_commit :send_email, if: :outbound?
  after_create_commit :broadcast_to_applicant
  after_create_commit :create_inbound_email_notification, if: :inbound?

  # Must distinguish between inboand and outbound email types otherise, every time a new inbound
  # reply is processed, the application will immediately send that same email back to our servers,
  # resulting in a broken email system
  enum email_type: {
    outbound: 'outbound',
    inbound: 'inbound'
  }

  def send_email
    #  'deliver_later' sends the email in the background
    ApplicantMailer.contact(email: self).deliver_later
  end

  def build_reply(email_id)
    #  Create the email being replied to using the id provided as an argument
    replying_to = Email.find(email_id)
    original_body = replying_to.body.body.to_html

    # Initialize the reply_email and return it
    email = Email.new(applicant_id: replying_to.applicant_id)
    email.subject = "re: #{replying_to.subject}"
    reply_intro = <<-HTML
      <br><br>--------<br>on #{replying_to.created_at.to_date} #{email.applicant.full_name} wrote:<br>

    HTML
    email.body = original_body.prepend(reply_intro)
    email
  end

  def broadcast_to_applicant
    broadcast_prepend_later_to(
      applicant, :emails,
      target: 'emails-list',
      partial: 'emails/list_item',
      locals: {
        emails: self,
        applicant: applicant
      }
    )
  end

  #  NOTE:  If you are new to using single table inheritance in Rails,
  #         InboundEmailNotification.create is equivalent to
  #         Notification.create(type: 'InboundEmailNotification').
  def create_inbound_email_notification
    InboundEmailNotification.create(
      user: user,
      params: {
        applicant: applicant,
        email: self
      }
    )
  end
end
