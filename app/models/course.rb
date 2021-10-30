# frozen_string_literal: true

class Course < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true

  has_many :source_relations,
           class_name: 'CourseRelationship',
           foreign_key: :source_id

  has_many :target_relations,
           class_name: 'CourseRelationship',
           foreign_key: :target_id

  has_many :course_connections

  has_many :related_courses,
           through: :course_connections

  has_many :users,
           inverse_of: :course
end
