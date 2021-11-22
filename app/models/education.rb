# frozen_string_literal: true

class Education < ApplicationRecord
  belongs_to :user, inverse_of: :educations
  belongs_to :course, inverse_of: :educations
  belongs_to :university, inverse_of: :educations

  validates :year,
            inclusion: { in: (1900..(Time.zone.now.utc.to_date.year + 10)), message: 'has to be a valid year' }

  delegate :name, to: :course, prefix: true
  delegate :name, to: :university, prefix: true

  def pretty_name
    "#{course.name} at #{university.name} in #{year}"
  end

  def to_h
    {
      course: course_name,
      university: university_name,
      year: year
    }
  end
end
