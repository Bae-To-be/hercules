# frozen_string_literal: true

FactoryBot.define do
  factory :user_report do
    association :from, factory: :user
    association :for_user, factory: :user
    association :user_report_reason
    comment { Faker::Alphanumeric.unique.alpha(number: 10) }
  end
end
