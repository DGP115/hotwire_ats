# frozen_string_literal: true

# Model for comments
class Comment < ApplicationRecord
  belongs_to :user
  #   :touch option to true, then the updated_at or updated_on timestamp on the associated object
  #    will be set to the current time whenever this object is saved or destroyed.
  belongs_to :commentable, polymorphic: true, counter_cache: :commentable_count, touch: true

  has_rich_text :comment

  after_create_commit :notify_mentioned_users

  def notify_mentioned_users
    mentioned_users.each do |mentioned_user|
      NotifyUserJob.perform_later(
        resource_id: id,
        resource_type: 'Comment',
        user_id: mentioned_user.id
      )
    end
  end

  def mentioned_users
    comment.body.attachments.select { |att| att.attachable.is_a?(User) }.map(&:attachable).uniq
  end

  #  Not longer used as this sends notifications in the foreground
  def create_notification(mentioned_user)
    Notification.create(
      user: mentioned_user,
      type: "#{commentable.class}CommentNotification",
      params: {
        user: user,
        applicant: commentable
      }
    )
  end
end
