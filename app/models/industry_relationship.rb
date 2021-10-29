# frozen_string_literal: true

class IndustryRelationship < ApplicationRecord
  belongs_to :source,
             class_name: 'Industry'

  belongs_to :target,
             class_name: 'Industry'

  validate :node_uniqueness,
           :same_entity

  private

  def node_uniqueness
    if IndustryConnection.exists?(industry_id: source_id,
                                  related_industry_id: target_id)
      errors.add(:base, 'This relationship already exists')
    end
  end

  def same_entity
    error.add(:base, 'Cannot link a industry to itself') if source_id == target_id
  end
end
