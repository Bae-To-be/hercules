# frozen_string_literal: true

FactoryBot.define do
  factory :verification_request do
    association :user
  end
end
