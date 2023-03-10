# frozen_string_literal: true

# Class definition for use of ApexCharts
class Charts::ApplicantsChart
  def initialize(account_id, params = {})
    @account_id = account_id
    @start_date = params[:start_date].presence || default_start_date
    @end_date = params[:end_date].presence || Date.today.end_of_day
  end

  def generate
    applicant_count_by_day = query_data
    zero_fill_dates(applicant_count_by_day)
  end

  private

  def query_data
    #  An ActiveRecord query to fetch applicants that match the date range given below,
    #  grouped into a hash with the day the applicants were created as the keys and the
    #  number of applicants that applied that day as the values.
    Applicant
      .includes(:job)
      .for_account(@account_id)
      .where(applicants: { created_at: @start_date..@end_date })
      .group('date(applicants.created_at)')
      .count
  end

  #   populate the applicant data hash with any days that had zero applicants apply.
  def zero_fill_dates(applicant_count_by_day)
    (@start_date.to_date..@end_date.to_date).each_with_object({}) do |date, hash|
      hash[date] = applicant_count_by_day.fetch(date, 0)
    end
  end

  def default_start_date
    90.days.ago
  end
end
