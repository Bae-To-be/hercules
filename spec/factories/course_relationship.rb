# frozen_string_literal: true

FactoryBot.define do
  factory :course_relationship do
    association :source, factory: :course
    association :target, factory: :course
  end
end
