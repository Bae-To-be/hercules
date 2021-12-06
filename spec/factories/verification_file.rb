# frozen_string_literal: true

FactoryBot.define do
  factory :verification_file do
    association :user
    file_type { :selfie }
    file { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/sample.jpeg'))) }
  end
end
