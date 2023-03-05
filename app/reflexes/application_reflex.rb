# frozen_string_literal: true

class ApplicationReflex < StimulusReflex::Reflex
  #  See /channels/application_cable/connection.rb

  delegate :current_user, to: :connection
end
