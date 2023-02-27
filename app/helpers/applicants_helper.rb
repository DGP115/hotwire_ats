# frozen_string_literal: true

#  Helper methods for applicant views: true
module ApplicantsHelper
  #  Set the sort criteia for applicants used in the filter form
  def applicant_sort_options_for_select
    [
      ['Application Date Ascending', 'created_at-asc'],
      ['Application Date Descending', 'created_at-desc']
    ]
  end
end
