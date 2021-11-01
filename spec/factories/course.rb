# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    name { Faker::Educator.unique.degree }
  end
end
