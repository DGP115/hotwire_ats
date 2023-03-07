# frozen_string_literal: true

#  Controller for the accounts portion of our Carrers section of the app
class Careers::AccountsController < CareersController # rubocop:disable Style/ClassAndModuleChildren
  def show
    @account = Account.find(params[:id])
  end
end
