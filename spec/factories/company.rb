# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    name { Faker::String.unique.random(length: 4) }
  end
end
