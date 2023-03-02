# frozen_string_literal: true

# App email model.  Store emails to applicants in the app for continuity.
class Email < ApplicationRecord
  has_rich_text :body

  belongs_to :applicant
  belongs_to :user

  validates_presence_of :subject

  after_create_commit :send_email

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
end
