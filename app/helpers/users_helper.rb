# frozen_string_literal: true

#  Helpers for user views
module UsersHelper
  def user_invite_info(user)
    unless user.invited_by.present?
      return "Signed up on #{user.created_at.in_time_zone('Eastern Time (US & Canada)')
                                            .strftime('%d-%b-%Y %I:%M%P')}"
    end

    if user.accepted_invite_at.present?
      "Signed up on #{user.accepted_invite_at
                          .in_time_zone('Eastern Time (US & Canada)')
                          .strftime('%d-%b-%Y %I:%M%P')}"
    else
      "Invited on #{user.invited_at
                        .in_time_zone('Eastern Time (US & Canada)')
                        .strftime('%d-%b-%Y %I:%M%P')}"
    end
  end
end
