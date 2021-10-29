# frozen_string_literal: true

class CourseConnection < ApplicationRecord
  belongs_to :course
  belongs_to :related_course,
             class_name: 'Course'
end
