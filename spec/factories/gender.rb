# frozen_string_literal: true

FactoryBot.define do
  factory :gender do
    name { Faker::Gender.unique.type }
  end
end
