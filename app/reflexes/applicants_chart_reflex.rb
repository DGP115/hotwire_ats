# frozen_string_literal: true

# Learn more at: https://docs.stimulusreflex.com/rtfm/reflex-classes
class ApplicantsChartReflex < ApplicationReflex
  def update
    report_data = retrieve_data(current_user.account_id, params)
    categories, series = assign_data(report_data)

    #  CableReady’s set_dataset_property operation allows us to update the x and
    #  y data attributes in the DOM.
    cable_ready
      .set_dataset_property(name: 'applicantsChartLabelsValue',
                            selector: '#applicants-chart-container',
                            value: categories)
      .set_dataset_property(name: 'applicantsChartSeriesValue',
                            selector: '#applicants-chart-container',
                            value: series)

    morph :nothing
  end

  # retrieve_data and assign_data fetch the data we need to build the chart.
  def retrieve_data(account_id, params)
    Charts::ApplicantsChart.new(account_id, params).generate
  end

  def assign_data(data)
    [data.keys.to_json, data.values.to_json]
  end
end
