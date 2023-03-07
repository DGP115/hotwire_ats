# frozen_string_literal: true

#  External, "Careers section", Jobs  Controller
class Careers::JobsController < CareersController # rubocop:disable Style/ClassAndModuleChildren
  #  NOTE:
  #   We not not use authenticate_user! here because these jobs are meant to be
  #   seen by the public, so should not require login to access.
  before_action :set_account, only: %i[index]
  before_action :set_job, only: %i[show]

  def index
    @jobs = @account.jobs.open.order(title: :asc)
  end

  def show
    #  TBD:  Why is this instantiating @account in job controller and not accounts controller?
    @account = @job.account
  end

  private

  def set_account
    @account = Account.find(params[:account_id])
  end

  def set_job
    @job = Job.includes(:account).find(params[:id])
  end
end
