# frozen_string_literal: true

# rails base class for teh model we create
class ApplicationRecord < ActiveRecord::Base
  include CableReady::Updatable
  primary_abstract_class
  # Since ordering records by primary key is not very useful when they are not in
  # sequential order, we can tell ActiveRecord to use created_at to order records when
  # no order is specified.
  self.implicit_order_column = 'created_at'
end
