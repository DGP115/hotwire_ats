# frozen_string_literal: true

#  Controller to handle the processing of emails to applicants
class EmailsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_applicant

  # The new action in a standard Rails CRUD controller renders the new.html.erb view. We are
  # short-circuiting that default rendering here. Instead, we render the emails form partial to a
  # string and then render cable_car operations. These operations are sent back to the browser as
  # a JSON payload that Mrujs handles.
  # This "inserts" the new email form into the empty slideover that exists on the index page.
  def new
    @email = Email.new

    html = render_to_string(partial: 'form', locals: { email: @email, applicant: @applicant })
    render operations: cable_car
      .inner_html('#slideover-content', html: html) # rubocop:disable Style/HashSyntax
      .text_content('#slideover-header', text: "Email #{@applicant.name}")
  end

  def create
    @email = Email.new(email_params)
    @email.applicant_id = @applicant.id
    @email.user_id = current_user.id
    @email.email_type = 'outbound'

    if @email.save
      html = render_to_string(partial: 'shared/flash_messages',
                              locals: { level: :success, content: 'Email sent!' })
      render operations: cable_car
        .inner_html('#flash-container', html: html) # rubocop:disable Style/HashSyntax
        .dispatch_event(name: 'submit:success')
    else
      html = render_to_string(partial: 'form',
                              locals: { applicant: @applicant, email: @email })
      render operations: cable_car
        .inner_html('#email-form', html: html), status: :unprocessable_entity # rubocop:disable Style/HashSyntax
    end
  end

  def index
    @emails = Email.where(applicant_id: params[:applicant_id])
                   .with_rich_text_body
                   .order(created_at: :desc)
  end

  def show
    @email = Email.find(params[:id])

    html = render_to_string(partial: 'email', locals: { email: @email })
    render operations: cable_car
      .inner_html('#slideover-content', html: html) # rubocop:disable Style/HashSyntax
      .text_content('#slideover-header', text: @email.subject)
  end

  private

  def set_applicant
    @applicant = Applicant.find(params[:applicant_id])
  end

  def email_params
    params.require(:email).permit(:subject, :body)
  end
end
