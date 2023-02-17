# frozen_string_literal: true

#  Our app's Jobs controller
class JobsController < ApplicationController
  #  authenticate_user! is provided by Devise
  before_action :authenticate_user!
  before_action :set_job, only: %i[show edit update destroy]

  # GET /jobs
  def index
    @jobs = Job.all
  end

  # GET /jobs/id
  def show; end

  # GET /jobs/new
  def new
    # The new action in a standard Rails CRUD controller renders the new.html.erb view. We are
    # short-circuiting that default rendering here. Instead, we render the jobs form partial to a
    # string and then render cable_car operations. These operations are sent back to the browser as
    # a JSON payload that Mrujs handles.
    html = render_to_string(partial: 'form', locals: { job: Job.new })
    render operations: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slideover-header', text: 'Post a new job')
  end

  # GET /jobs/id/edit
  def edit; end

  # POST /jobs
  def create
    @job = Job.new(job_params)
    @job.account_id = current_user.account_id

    if @job.save
      redirect_to @job, notice: 'Job was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /jobs/id
  def update
    if @job.update(job_params)
      redirect_to @job, notice: 'Job was successfully updated.'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # DELETE /jobs/1
  def destroy
    if @job.destroy
      redirect_to jobs_url, notice: 'Job was successfully destroyed.'
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = Job.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def job_params
    params.require(:job).permit(:title, :status, :job_type, :location, :account_id)
  end
end
