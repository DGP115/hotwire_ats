# frozen_string_literal: true

#  Controller to handle users.  TBD:  How this works with Devise
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users = User.where(account_id: current_user.account_id).order(last_name: :asc)
  end

  def new
    @user = User.new
    html = render_to_string(partial: 'form', locals: { user: @user })
    render operations: cable_car
      .inner_html('#slideover-content', html: html)
      .text_content('#slideover-header', text: 'Add a new User')
  end

  def create
    @user = User.new(user_params)
    @user.account_id = current_user.account_id

    #  NOTE:  Devise requires a password to persist a user in the database, so we set a random
    #         password for the user here.
    #         The new user will never use this random password. We provide a form for new users
    #         to activate their account and set their own password.
    @user.password = SecureRandom.alphanumeric(24)

    @user.invited_at = Time.current
    @user.invited_by_id = current_user.id
    # A 'friendly_token' is a url-safe secure token created (by Devise) from a user_id
    @user.invite_token = Devise.friendly_token

    if @user.save
      UserInviteMailer.invite(@user).deliver_later
      html = render_to_string(partial: 'user', locals: { user: @user })
      render operations: cable_car
        .prepend('#users', html: html)
        .dispatch_event(name: 'submit:success')
    else
      html = render_to_string(partial: 'form', locals: { user: @user })
      render operations: cable_car
        .inner_html('#user-form', html: html), status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    set_name
    if @user.update(user_params.except(:name))
      render partial: 'user', locals: { user: @user }
    else
      render partial: 'edit_form', locals: { user: @user }
    end
  end

  def destroy
    @user.destroy
    render operations: cable_car.remove(selector: dom_id(@user))
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :name)
  end

  def set_name
    first_name, last_name = user_params[:name].split(' ', 2)
    @user.first_name = first_name
    @user.last_name = last_name
  end
end
