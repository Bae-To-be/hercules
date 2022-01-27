# frozen_string_literal: true

FactoryBot.define do
  factory :user_report_reason do
    name { Faker::Alphanumeric.unique.alpha(number: 10) }
  end
end
