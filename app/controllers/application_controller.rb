# frozen_string_literal: true

# Rails base class for controllers.
class ApplicationController < ActionController::Base
  include CableReady::Broadcaster
end
