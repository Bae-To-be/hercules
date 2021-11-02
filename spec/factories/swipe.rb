# frozen_string_literal: true

FactoryBot.define do
  factory :swipe do
    association :from, factory: :user
    association :to, factory: :user
    direction { ['left', 'right'].sample }
  end
end
