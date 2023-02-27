# frozen_string_literal: true

# app-specific helper methods for views
module ApplicationHelper
  # rubocop:disable Metrics/MethodLength
  # formating for flash messages
  def flash_class(level)
    case level.to_sym
    when :notice
      'bg-blue-900 border-blue-900'
    when :success
      'bg-green-900 border-green-900'
    when :alert
      'bg-red-900 border-red-900'
    when :error
      'bg-red-900 border-red-900'
    else
      'bg-blue-900 border-blue-900'
    end
  end

  def job_options_for_select(account_id)
    Job.where(account_id: account_id).order(:title).pluck(:title, :id)
  end

  #  When the applicants page is opened, intialize it with the last filter criteria.
  #  Otherwise the page can be filtereed in a way that is not obvious, as the filter field values
  #  don't reflect the current filter in effect.
  #  This method retrieves the applied filter for a particular user and resource combination
  def fetch_filter_key(resource, user_id, key)
    Kredis.hash("#{resource}_filters:#{user_id}")[key]
  end
end
