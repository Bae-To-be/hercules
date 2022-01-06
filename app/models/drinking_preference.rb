# frozen_string_literal: true

class DrinkingPreference < ApplicationRecord
  has_many :users,
           inverse_of: :drinking_preference

  def to_h
    {
      id: id,
      name: name
    }
  end
end
