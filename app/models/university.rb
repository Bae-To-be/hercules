class University < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: true
end
