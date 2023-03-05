# frozen_string_literal: true

module ApplicationCable
  #  Because we are referencing current_user in the reflex to update the notification count,
  #  we need to ensure that StimulusReflex has access to the current_user object.
  #  This codes comes from :  https://docs.stimulusreflex.com/guide/authentication.html
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      if (current_user = env['warden'].user)
        current_user
      else
        reject_unauthorized_connection
      end
    end
  end
end
