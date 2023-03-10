# frozen_string_literal: true

class ApplicationReflex < StimulusReflex::Reflex
  #  See /channels/application_cable/connection.rb
  #  This statement is needed to enable reflexes access to the session

  delegate :current_user, to: :connection
end
