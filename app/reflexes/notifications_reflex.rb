# frozen_string_literal: true

#  The StimulusRefles that serves as the server-side of the notifications 'read' update
class NotificationsReflex < ApplicationReflex
  #  The method we call (using stimulate) from the 'notifications' Stimulus controller.
  #  In read, we first set the notification we are acting on with element.unsigned[:public].
  #  StimulusReflex leverages Rails global ids to provide this handy way to access model instances.
  def read
    notification = element.unsigned[:public]

    #  Set the current notification to 'read'
    notification.read!

    #  Update the count of unread notifications
    update_notification_count

    #  Finally, morph :nothing tells StimulusReflex not to run a morph since we handled DOM updates
    #  in the beforeRead callback and via CableReady with update_notification_count
    morph :nothing
  end

  private

  def update_notification_count
    count = current_user.notifications.unread.count
    if count.positive?
      cable_ready.text_content(selector: '#notification-count', text: count)
    else
      cable_ready.remove(selector: '#notification-count')
    end
  end
end
