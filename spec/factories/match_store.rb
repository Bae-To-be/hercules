# frozen_string_literal: true

FactoryBot.define do
  factory :match_store do
    association :source, factory: :user
    association :target, factory: :user
  end
end
