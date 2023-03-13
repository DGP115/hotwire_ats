# frozen_string_literal: true

# Model for comments
class Comment < ApplicationRecord
  belongs_to :user
  #   :touch option to true, then the updated_at or updated_on timestamp on the associated object
  #    will be set to the current time whenever this object is saved or destroyed.
  belongs_to :commentable, polymorphic: true, counter_cache: :commentable_count, touch: true

  has_rich_text :comment
end
