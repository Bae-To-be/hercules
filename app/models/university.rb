# frozen_string_literal: true

class University < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true

  has_many :users,
           inverse_of: :university
end
