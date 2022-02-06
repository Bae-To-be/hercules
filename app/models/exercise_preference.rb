# frozen_string_literal: true

class ExercisePreference < ApplicationRecord
  has_many :users,
           inverse_of: :exercise_preference

  def to_h
    {
      id: id,
      name: name
    }
  end
end
