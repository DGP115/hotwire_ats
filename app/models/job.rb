# frozen_string_literal: true

# App job model
class Job < ApplicationRecord
  belongs_to :account
  has_many :applicants, dependent: :destroy
  validates_presence_of :title, :status, :job_type, :location
  has_rich_text :description

  enum status: {
    draft: 'draft',
    open: 'open',
    closed: 'closed'
  }

  enum job_type: {
    full_time: 'full_time',
    part_time: 'part_time'
  }

  # ---------------Methods to service job filtering -----------
  #  Define, as an unchangeable constant, the criteria by which jobs can be filtered
  FILTER_PARAMS = %i[query status sort].freeze

  #  To isolate users to only those jobs within their account
  scope :for_account, ->(account_id) { where(jobs: { account_id: account_id }) }

  # scope :name, ->(input argument) { conditional ? branch_if_true : branch_if_false }
  scope :for_status, ->(status) { status.present? ? where(status: status) : all }
  scope :search_by_title, ->(query) { query.present? ? where('title ILIKE ?', "%#{query}%") : all }
  scope :sorted, ->(selection) { selection.present? ? apply_sort(selection) : all }

  # Recall from jobs_helper.rb that 'selection' is a string comprising
  # "sort_column-sort_order"
  def self.apply_sort(selection)
    return if selection.blank?

    sort_column, sort_order = selection.split('-')
    order("#{sort_column} #{sort_order}")
  end

  #  Recall the argument 'filters' here is set in the filterable concern
  #  in method apply_filters
  def self.filter(filters)
    search_by_title(filters['query'])
      .for_status(filters['status'])
      .sorted(filters['sort'])
  end
end
