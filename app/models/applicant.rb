# frozen_string_literal: true

# Job applicant model
class Applicant < ApplicationRecord
  #  Inlude pgsearch model to enable postgresql full-text searching [via gem pg_search]
  include PgSearch::Model
  pg_search_scope :text_search,
                  against: %i[first_name last_name email], # Identifying the columns to search
                  using: {
                    tsearch: {                           # tsearch = full-text search
                      any_word: true,                    # consider a match if any word matches
                      prefix: true                       # consider a match if any word-part matches
                    }
                  }

  belongs_to :job

  validates_presence_of :first_name, :last_name, :email

  has_one_attached :resume
  has_many :emails, dependent: :destroy

  has_many :comments, as: :commentable, dependent: :destroy, counter_cache: :commentable_count

  enum stage: {
    application: 'application',
    interview: 'interview',
    offer: 'offer',
    hired: 'hire'
  }

  enum status: {
    active: 'active',
    inactive: 'inactive'
  }

  # ---------------Methods to service applicant filtering -----------
  #  Define, as an unchangeable constant, the criteria by which applicant can be filtered
  FILTER_PARAMS = %i[query job sort].freeze

  # scope :name, ->(input argument) { conditional ? branch_if_true : branch_if_false }
  scope :for_job, ->(job_id) { job_id.present? ? where(job_id: job_id) : all }
  scope :search, ->(query) { query.present? ? text_search(query) : all }
  #  apply_sort is defined below
  scope :sorted, ->(selection) { selection.present? ? apply_sort(selection) : all }

  #  To isolate users to only those applicants within their account
  scope :for_account, ->(account_id) { where(jobs: { account_id: account_id }) }

  # Recall from applicants_helper.rb that 'selection' is a string comprising
  # "sort_column-sort_order"
  def self.apply_sort(selection)
    sort_column, sort_order = selection.split('-')
    order("applicants.#{sort_column} #{sort_order}")
  end

  #  Recall the argument 'filters' here is set in the filterable concern
  #  in method apply_filters
  def self.filter(filters)
    includes(:job)
      .search(filters['query'])
      .for_job(filters['job'])
      .sorted(filters['sort'])
  end

  # -------------------------------------------------------------------------

  def name
    [first_name, last_name].join(' ')
  end
end
