
# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    association :author, factory: :user
    association :match_store, factory: :match_store
  end
end
