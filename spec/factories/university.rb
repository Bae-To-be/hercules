# frozen_string_literal: true

FactoryBot.define do
  factory :university do
    name { Faker::University.unique.name }
  end
end
