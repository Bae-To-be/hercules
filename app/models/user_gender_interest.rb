# frozen_string_literal: true

class UserGenderInterest < ApplicationRecord
  belongs_to :user
  belongs_to :gender

  validates :user_id, uniqueness: { scope: :gender_id }
end
