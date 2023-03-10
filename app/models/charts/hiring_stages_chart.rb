# frozen_string_literal: true

# Class definition for use of ApexCharts
class Charts::HiringStagesChart
  def initialize(account_id, job_id = nil)
    @account_id = account_id
    @job_id = job_id
  end

  def generate
    query_data
  end

  private

  #  returns a hash with stage names as the keys and
  #                      the number of applicants in each stage as the values.
  #  Note that the below uses scopes
  def query_data
    Applicant
      .includes(:job)
      .for_account(@account_id)
      .for_job(@job_id)
      .group('stage')
      .count
  end
end
