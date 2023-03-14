# frozen_string_literal: true

#  Our background job for notifying users of new emails and new mentions
class NotifyUserJob < ApplicationJob
  queue_as :default

  #  The NotifyUserJob will create multiple types of notifications (right now we can notify users
  #  of new mentions and new inbound emails), so we pass in the information that it needs to find
  #  the record and create the notification.
  def perform(resource_id:, resource_type:, user_id:)
    resource = resource_type.constantize.find(resource_id)
    user = User.find(user_id)
    resource.create_notification(user)
  end
end
