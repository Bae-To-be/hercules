# frozen_string_literal: true

class Swipe < ApplicationRecord
  belongs_to :from,
             class_name: 'User',
             inverse_of: :swipes_performed

  belongs_to :to,
             class_name: 'User',
             inverse_of: :swipes_received

  enum direction: { left: 0, right: 1 }

  validates :to,
            uniqueness: { scope: :from, message: 'user is already swiped' }

  validate :from_and_to_different

  validate :under_daily_limit,
           on: :create

  scope :in_last_day, -> { where('created_at >= ?', Time.zone.now - 24.hours) }

  private

  def under_daily_limit
    return unless Swipe.where(from: from).in_last_day.count >= ENV.fetch('DEFAULT_DAILY_SWIPE_LIMIT').to_i

    errors.add(:base, 'daily limit crossed')
    throw(:abort)
  end

  def from_and_to_different
    return unless from_id == to_id

    errors.add(:base, 'cannot swipe yourself')
    throw(:abort)
  end
end
