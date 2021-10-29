# frozen_string_literal: true

class University < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true
end
