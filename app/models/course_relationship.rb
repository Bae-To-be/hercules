# frozen_string_literal: true

class CourseRelationship < ApplicationRecord
  belongs_to :source,
             class_name: 'Course'
  belongs_to :target,
             class_name: 'Course'

  validate :node_uniqueness,
           :same_entity

  private

  def node_uniqueness
    if CourseConnection.exists?(course_id: source_id,
                                related_course_id: target_id)
      errors.add(:base, 'This relationship already exists')
    end
  end

  def same_entity
    error.add(:base, 'Cannot link a course to itself') if source_id == target_id
  end
end
