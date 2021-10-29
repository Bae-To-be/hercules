class Course < ApplicationRecord
  validates :name,
    presence: true,
    uniqueness: true
end
