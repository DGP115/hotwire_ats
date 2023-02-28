# frozen_string_literal: true

#  Controller to handle the display of applicant resumes
class ResumesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_applicant, only: %i[show]

  # Route:
  #  Prefix           | applicant_resume
  #    Verb           | GET
  #    URI            | /applicants/:applicant_id/resume(.:format)
  # Controller#Action | resumes#show
  def show
    @resume = @applicant.resume
  end

  private

  def set_applicant
    @applicant = Applicant.find(params[:applicant_id])
  end
end
