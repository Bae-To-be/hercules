# frozen_string_literal: true

class WorkTitle < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true

  has_many :source_relations,
           class_name: 'WorkTitleRelationship',
           foreign_key: :source_id

  has_many :target_relations,
           class_name: 'WorkTitleRelationship',
           foreign_key: :target_id

  has_many :work_title_connections

  has_many :related_work_titles,
           through: :work_title_connections
end