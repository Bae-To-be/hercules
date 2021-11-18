# frozen_string_literal: true

class WorkTitle < ApplicationRecord
  include PgSearch::Model

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

  has_many :users,
           inverse_of: :work_title

  pg_search_scope :search_by_name,
                  against: :name,
                  using: {
                    tsearch: {
                      prefix: true,
                      dictionary: 'english'
                    },
                    trigram: {
                      threshold: 0.6
                    }
                  }

  def to_h
    {
      id: id,
      name: name
    }
  end
end
