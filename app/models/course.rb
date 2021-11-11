# frozen_string_literal: true

class Course < ApplicationRecord
  include PgSearch::Model

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

  pg_search_scope :search_by_name, against: :name, using: {
    tsearch: {
      prefix: true,
      dictionary: 'english'
    },
    trigram: {}
  }

  def to_h
    {
      id: id,
      name: name
    }
  end
end
