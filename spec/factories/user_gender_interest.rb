# frozen_string_literal: true

FactoryBot.define do
  factory :user_gender_interest do
    association :user
    association :gender
  end
end
