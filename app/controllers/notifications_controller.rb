# frozen_string_literal: true

#  Controller for Notifications to users of new emails
class NotificationsController < ApplicationController
  def index
    @notifications = current_user.notifications.unread.order(created_at: :desc)
  end
end
