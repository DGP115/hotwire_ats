# frozen_string_literal: true

# Job applicant model
class Applicant < ApplicationRecord
  belongs_to :job

  validates_presence_of :first_name, :last_name, :email

  has_one_attached :resume

  enum stage: {
    application: 'application',
    interview: 'interview',
    offer: 'offer',
    hired: 'hire'
  }

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  def full_name
    [first_name, last_name].join(' ')
  end
end
