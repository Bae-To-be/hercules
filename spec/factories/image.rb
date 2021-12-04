# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    association :user
    position { Faker::Number.unique.non_zero_digit }
    file { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/sample.jpeg'))) }
  end
end
