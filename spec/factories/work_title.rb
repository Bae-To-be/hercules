# frozen_string_literal: true

FactoryBot.define do
  factory :work_title do
    name { Faker::Job.unique.title }
  end
end
