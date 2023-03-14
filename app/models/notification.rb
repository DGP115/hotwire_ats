# frozen_string_literal: true

# App (email) notification model
class Notification < ApplicationRecord
  #  RECALL:  We are using single-table inheritance to model the various subclasses of notification
  #           we will use.
  #   Include Rails url_helpers here because each notificastion subclkss will need to access
  #   path helpers.
  include Rails.application.routes.url_helpers

  belongs_to :user

  after_create_commit :update_users_notification_container

  scope :unread, -> { where(read_at: nil) }

  # RECALL:  The params column, for notifications table, is of format jsonb
  #          That is so it can store, in binary form, the applicant and email info
  #          we want to include in a notifiction.
  # The serialize command translates the binary format into run-time-usable format
  serialize :params

  #  NOTE:
  #       In /notifications/index.html.erb, we use Rails collection rendering to render all
  #       @notifications, which, recall, can be of a number of subclasses.
  #       For collection rendering to work with the multiple class names that come with using
  #       single table inheritance we need to update the Notification model to override the
  #       Rails default 'to_partial_path'.
  #         Context:  Models that inherit from ActiveRecord::Base
  #                   will return, to render, a partial name based on the model’s name by default.
  #
  #   Without this change, collection rendering for notifications would attempt to look up the
  #   partial based on each notification's class and we would get an error telling us that no
  #   partial named "inbound_email_notifications/inbound_email_notification" exists.
  def to_partial_path
    'notifications/notification'
  end

  #  Call for the replacement of the contents of 'notifications-container' whenever
  #  a new notification is comitted.
  def update_users_notification_container
    broadcast_replace_later_to(
      user, :notifications,
      target: 'notifications-container',
      partial: 'nav/notifications',
      locals: {
        user: user
      }
    )
  end

  def read!
    update_column(:read_at, Time.current)
  end
end
