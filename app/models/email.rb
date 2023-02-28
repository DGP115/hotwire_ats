# frozen_string_literal: true

# App email model.  Store emails to applicants in the app for continuity.
class Email < ApplicationRecord
  has_rich_text :body

  belongs_to :applicant
  belongs_to :user

  validates_presence_of :subject

  after_create_commit :send_email

  def send_email
    #  'deliver_later' sends the email in the background
    ApplicantMailer.contact(email: self).deliver_later
  end
end
