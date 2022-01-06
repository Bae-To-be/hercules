# frozen_string_literal: true

class SmokingPreference < ApplicationRecord
  has_many :users,
           inverse_of: :smoking_preference

  def to_h
    {
      id: id,
      name: name
    }
  end
end
