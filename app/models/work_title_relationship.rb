# frozen_string_literal: true

class WorkTitleRelationship < ApplicationRecord
  belongs_to :source,
             class_name: 'WorkTitle'
  belongs_to :target,
             class_name: 'WorkTitle'

  validate :node_uniqueness,
           :same_entity

  private

  def node_uniqueness
    if WorkTitleConnection.exists?(work_title_id: source_id,
                                   related_work_title_id: target_id)
      errors.add(:base, 'This relationship already exists')
    end
  end

  def same_entity
    error.add(:base, 'Cannot link a title to itself') if source_id == target_id
  end
end
