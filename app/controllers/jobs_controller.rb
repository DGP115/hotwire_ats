# frozen_string_literal: true

#  Our app's Jobs controller
class JobsController < ApplicationController
  include Filterable
  #  authenticate_user! is provided by Devise
  before_action :authenticate_user!
  before_action :set_job, only: %i[show edit update destroy]

  # GET /jobs
  def index
    @jobs = filter!(Job).for_account(current_user.account_id)
  end

  # GET /jobs/id
  def show; end

  # GET /jobs/new
  def new
    # The new action in a standard Rails CRUD controller renders the new.html.erb view. We are
    # short-circuiting that default rendering here. Instead, we render the jobs form partial to a
    # string and then render cable_car operations. These operations are sent back to the browser as
    # a JSON payload that Mrujs handles.
    # This "inserts" the new job form into the empty slideover that exists on the index page.
    html = render_to_string(partial: 'form', locals: { job: Job.new })
    render operations: cable_car
      .inner_html('#slideover-content', html: html) # rubocop:disable Style/HashSyntax,
      .text_content('#slideover-header', text: 'Post a new job')
  end

  # GET /jobs/id/edit
  def edit
    html = render_to_string(partial: 'form', locals: { job: @job })
    render operations: cable_car
      .inner_html('#slideover-content', html: html) # rubocop:disable Style/HashSyntax
      .text_content('#slideover-header', text: 'Edit this job')
  end

  # POST /jobs
  def create # rubocop:disable Metrics/MethodLength
    @job = Job.new(job_params)
    @job.account_id = current_user.account_id

    if @job.save
      html = render_to_string(partial: 'job', locals: { job: @job })
      render operations: cable_car
        .prepend('#jobs', html: html) # rubocop:disable Style/HashSyntax
        .dispatch_event(name: 'submit:success')
    else
      html = render_to_string(partial: 'form', locals: { job: @job })
      render operations: cable_car
        .inner_html('#job-form', html: html), status: :unprocessable_entity # rubocop:disable Style/HashSyntax
    end
  end

  # PATCH/PUT /jobs/id
  def update
    if @job.update(job_params)
      html = render_to_string(partial: 'job', locals: { job: @job })
      render operations: cable_car
        .replace(dom_id(@job), html: html) # rubocop:disable Style/HashSyntax
        .dispatch_event(name: 'submit:success')
    else
      html = render_to_string(partial: 'form', locals: { job: @job })
      render operations: cable_car
        .inner_html('#job-form', html: html), status: :unprocessable_entity # rubocop:disable Style/HashSyntax
    end
  end

  # DELETE /jobs/1
  def destroy
    render operations: cable_car.remove(selector: dom_id(@job))
    render 'edit', status: :unprocessable_entity unless @job.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_job
    @job = Job.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def job_params
    params.require(:job).permit(:title, :status, :job_type, :location, :account_id, :description)
  end
end
