# frozen_string_literal: true

# Rails base class for controllers.
class ApplicationController < ActionController::Base
  include CableReady::Broadcaster

  before_action :turbo_frame_request_variant

  private

  def turbo_frame_request_variant
    # turbo_frame_request? is a method provided by turbo.
    # Here, we are telling rails that if a get request includes a turbo_frame header,
    # the corresponding controller action is to use the custom_variant identified below
    # to determine what should be rendered.
    request.variant = :turbo_frame if turbo_frame_request?
  end
end
