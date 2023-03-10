# frozen_string_literal: true

# Learn more at: https://docs.stimulusreflex.com/rtfm/reflex-classes
class HiringStagesReflex < ApplicationReflex
  def update
    data = retrieve_data(params[:job_id])
    stage_labels, stage_series = assign_data(data)

    #  CableReady’s set_dataset_property operation allows us to update the hiring-stages-labels and
    #  hiring-stages data attributes in the DOM.
    cable_ready
      .set_dataset_property(
        name: 'hiringStagesLabelsValue',
        selector: '#stage-chart-container',
        value: stage_labels
      )
      .set_dataset_property(
        name: 'hiringStagesSeriesValue',
        selector: '#stage-chart-container',
        value: stage_series
      )
      .broadcast

    morph :nothing
  end

  # retrieve_data and assign_data fetch the data we need to build the chart.

  def retrieve_data(job_id)
    Charts::HiringStagesChart.new(current_user.account_id, job_id).generate
  end

  def assign_data(data)
    [data.keys.map(&:humanize).to_json, data.values.to_json]
  end
end
