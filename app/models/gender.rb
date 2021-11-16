# frozen_string_literal: true

class Gender < ApplicationRecord
  has_many :users,
           inverse_of: :gender

  has_many :user_gender_interests,
           inverse_of: :gender

  validates :name,
            presence: true,
            uniqueness: true

  def to_h
    {
      id: id,
      name: name
    }
  end
end
