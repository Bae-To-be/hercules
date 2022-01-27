# frozen_string_literal: true

class MatchStore < ApplicationRecord
  belongs_to :source,
             class_name: 'User'
  belongs_to :target,
             class_name: 'User'
  belongs_to :closed_by,
             class_name: 'User',
             optional: true

  validate :node_uniqueness,
           :same_entity,
           on: :create

  has_many :messages,
           inverse_of: :match_store,
           dependent: :destroy

  def other_user(some_user)
    User.find([source_id, target_id].detect { |matched_id| matched_id != some_user.id })
  end

  def updated_at_int
    updated_at.to_datetime.strftime('%Q')
  end

  private

  def node_uniqueness
    if Match.exists?(user_id: source_id,
                     matched_user_id: target_id)
      errors.add(:base, 'This relationship already exists')
    end
  end

  def same_entity
    error.add(:base, 'Cannot match a user with himself') if source_id == target_id
  end
end
