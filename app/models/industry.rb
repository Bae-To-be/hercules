# frozen_string_literal: true

class Industry < ApplicationRecord
  validates :name,
            presence: true,
            uniqueness: true

  has_many :source_relations,
           class_name: 'IndustryRelationship',
           foreign_key: :source_id

  has_many :target_relations,
           class_name: 'IndustryRelationship',
           foreign_key: :target_id

  has_many :industry_connections

  has_many :related_industries,
           through: :industry_connections
end
