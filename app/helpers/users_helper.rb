# frozen_string_literal: true

#  Helpers for user views
module UsersHelper
  def user_invite_info(user)
    return "Signed up on #{user.created_at.strftime('%d-%b-%Y %I:%M%p %Z')}" unless
      user.invited_by.present?

    if user.accepted_invite_at.present?
      "Signed up on #{user.accepted_invite_at.strftime('%d-%b-%Y %I:%M%p %Z')}"
    else
      "Invited on #{user.invited_at.strftime('%d-%b-%Y %I:%M%p %Z')}"
    end
  end
end
