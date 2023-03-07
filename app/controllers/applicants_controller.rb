# frozen_string_literal: true

#  Our app's applicants controller
class ApplicantsController < ApplicationController
  include Filterable

  before_action :set_applicant, only: %i[show edit update destroy change_stage]
  before_action :authenticate_user!

  # GET /applicants
  def index
    # This returns a hash with stage value as key(s) and associated
    # account-specific applicants as values
    @grouped_applicants = filter!(Applicant)
                          .for_account(current_user.account_id)
                          .group_by(&:stage)

    # NOTE:  See application_controller.
    #  Normally the index action would render index.html.erb, but we have set it up
    #  such that IFF the get request includes a turbo_frame_id, a custom_variant will
    #  be rendered instead [index.html+turbo_frame.erb ]
  end

  # GET /applicants/id
  def show; end

  # GET /applicants/new
  def new
    html = render_to_string(partial: 'form', locals: { applicant: Applicant.new })
    render operations: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slideover-header', text: 'Add an applicant')
  end

  # GET /applicants/id/edit
  def edit; end

  # POST /applicants
  def create
    @applicant = Applicant.new(applicant_params)

    if @applicant.save
      html = render_to_string(partial: 'card', locals: { applicant: @applicant })
      render operations: cable_car
        .dispatch_event(name: 'submit:success')
    else
      html = render_to_string(partial: 'form', locals: { applicant: @applicant })
      render operations: cable_car
        .inner_html('#applicant-form', html: html), status: :unprocessable_entity
    end
  end

  def change_stage
    @applicant.update(applicant_params)
    #  Sends header only to the browser
    head :ok
  end

  def update
    if @applicant.update(applicant_params)
      flash[:notice] = 'Applicant was updated successfully.'
      redirect_to applicants_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  # DELETE /applicants/1 or /applicants/1.json
  def destroy
    @applicant.destroy

    respond_to do |format|
      format.html { redirect_to applicants_url, notice: 'Applicant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_applicant
    @applicant = Applicant.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def applicant_params
    params.require(:applicant).permit(:first_name, :last_name, :email, :phone,
                                      :stage, :status, :job_id, :resume)
  end

  def search_params
    params.permit(:query, :job, :sort)
  end
end
