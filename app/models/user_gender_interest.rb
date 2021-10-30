# frozen_string_literal: true

class UserGenderInterest < ApplicationRecord
  belongs_to :user
  belongs_to :gender
end
