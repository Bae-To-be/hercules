# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    birthday { Time.zone.at(rand * Time.now.to_i) }
  end
end
