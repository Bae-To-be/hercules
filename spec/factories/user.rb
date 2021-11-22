# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    birthday { Time.now.utc.to_date - 20.years }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
  end
end
