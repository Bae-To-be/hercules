# frozen_string_literal: true

FactoryBot.define do
  factory :image do
    association :user
    position { user.id + Faker::Number.non_zero_digit }
    file { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/sample.jpeg'))) }
  end
end
