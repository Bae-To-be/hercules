# frozen_string_literal: true

class Swipe < ApplicationRecord
  include ActionView::Helpers::DateHelper

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

  def from_hash
    {
      id: id,
      user: to.basic_hash,
      time_since_creation: time_since_creation
    }
  end

  def to_hash
    {
      id: id,
      user: from.basic_hash,
      time_since_creation: time_since_creation
    }
  end

  private

  def time_since_creation
    "#{time_ago_in_words(created_at)} ago"
  end

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
