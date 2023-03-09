# frozen_string_literal: true

#  Controller to handle  invitations to new users
class InvitesController < ApplicationController
  def new
    @user = User.find_by(invite_token: params[:token])

    return if params[:token].present? && @user.present?

    redirect_to root_path, error: 'Invalid invitation code.'
  end

  def create
    @user = User.find_by(invite_token: params[:user][:token])

    if @user&.update(user_params)
      @user.update_columns(invite_token: nil, accepted_invite_at: Time.current)
      sign_in(@user)
      flash[:success] = 'Invitation successfully accepted.  Welcome to Hotwired_ATS!'
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    # Resend invitation
    @user.reset_invite!(current_user)
    UserInviteMailer.invite(@user).deliver_later

    flash_html = render_to_string(
      partial: 'shared/flash',
      locals: { level: :success,
                content: "Resent invitation to #{@user.full_name}" }
    )
    render operations: cable_car
      .inner_html('#flash-container', html: flash_html)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password)
  end
end
