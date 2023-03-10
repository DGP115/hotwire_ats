# frozen_string_literal: true

#  Controller for charts - any charts
class ChartsController < ApplicationController
  before_action :set_chart
  before_action :authenticate_user!

  def show
    #  Instantiate a chart by "constantizing" the class name passed in into what rails
    #  can use as a class identifier.
    report_data = @chart.constantize.new(current_user.account_id).generate

    #  Subdivide the data prepared by the chart.generate into the 'x' and 'y' data values
    @labels = report_data.keys.to_json
    @series = report_data.values.to_json

    #  Build the name of the chart partial to use from the chart class name [passed in]
    @chart_partial = chart_to_partial
  end

  private

  #  Here:  we pass in teh class name of teh chart we want to render, e.g. 'Chart::ApplicantsChart'
  def set_chart
    @chart = params[:chart_type]
  end

  def chart_to_partial
    @chart.gsub('Charts::', '').underscore
  end
end
