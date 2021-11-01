# frozen_string_literal: true

class Swipe < ApplicationRecord
  belongs_to :from,
             class_name: 'User',
             inverse_of: :swipes_performed

  belongs_to :to,
             class_name: 'User',
             inverse_of: :swipes_received

  enum direction: { left: 0, right: 1 }

  validate :from_and_to_different

  validates :to,
            uniqueness: { scope: :from, message: 'user is already swiped' }

  private

  def from_and_to_different
    errors.add(:base, 'cannot swipe yourself') if from_id == to_id
  end
end
