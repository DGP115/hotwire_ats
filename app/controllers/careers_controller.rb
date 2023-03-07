# frozen_string_literal: true

#  Carrers Controller
class CareersController < ApplicationController
  #  The CareersController is not serving any routes.
  #  Instead, we will use the CareersController as a base for the controllers in the
  #  Careers namespace, defining a new careers layout for these controllers.
  layout 'careers'
end
