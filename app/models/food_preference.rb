# frozen_string_literal: true

class FoodPreference < ApplicationRecord
  has_many :users,
           inverse_of: :food_preference

  def to_h
    {
      id: id,
      name: name
    }
  end
end
