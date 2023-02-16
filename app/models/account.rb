# frozen_string_literal: true

# App Account model
class Account < ApplicationRecord
  validates_presence_of :name
  has_many :users, dependent: :destroy
end
