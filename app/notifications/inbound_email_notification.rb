# frozen_string_literal: true

# Subclass of Notification for Inbound Replies
class InboundEmailNotification < Notification
  def message
    "#{params[:email].subject} from #{params[:applicant].full_name}"
  end

  def url
    applicant_email_path(params[:applicant], params[:email])
  end
end
