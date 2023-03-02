# frozen_string_literal: true

# app-specific helper methods for views relevant to emails
module EmailsHelper
  def email_type_icon(email_type)
    email_type == 'inbound' ? 'arrow-circle-right' : 'arrow-circle-left'
  end
end
