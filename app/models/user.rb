# frozen_string_literal: true

class User < ApplicationRecord
  extend ArrayEnum

  GENDERS = { 'male' => 0, 'female' => 1 }.freeze

  enum gender: GENDERS
  array_enum interested_in: GENDERS

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true
  validates :gender, presence: true
end
