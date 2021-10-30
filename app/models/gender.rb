# frozen_string_literal: true

class Gender < ApplicationRecord
  has_many :users,
           inverse_of: :gender

  has_many :user_gender_interests,
           inverse_of: :gender
end
