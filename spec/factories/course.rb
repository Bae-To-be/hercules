# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    name { Faker::String.unique.random(length: 4) }
  end
end
