# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    name { Faker::Alphanumeric.unique.alpha(number: 10) }
  end
end
