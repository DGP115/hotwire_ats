# frozen_string_literal: true

#  Class to handle mailing of invitations to new users of this app
class UserInviteMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_invite_mailer.invite.subject
  #
  def invite(user)
    @user = user
    @inviting_user = user.invited_by

    mail(
      to: @user.email,
      subject: "#{@user.invited_by.full_name} invites you to join Hotwired_ATS"
    )
  end
end
