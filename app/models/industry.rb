# frozen_string_literal: true

class Industry < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true
end
