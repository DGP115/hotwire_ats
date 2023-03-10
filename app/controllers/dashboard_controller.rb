# frozen_string_literal: true

#  Our app's dashboard controller
class DashboardController < ApplicationController
  before_action :authenticate_user!

  def show; end
end
