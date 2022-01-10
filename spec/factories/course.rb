# frozen_string_literal: true

FactoryBot.define do
  factory :course do
    name { Faker::Educator.unique.course_name }
  end
end
