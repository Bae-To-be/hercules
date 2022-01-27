# frozen_string_literal: true

class Match < ApplicationRecord
  self.primary_key = 'id'

  include ActionView::Helpers::DateHelper

  belongs_to :user,
             class_name: 'User'
  belongs_to :matched_user,
             class_name: 'User'
  belongs_to :closed_by,
             class_name: 'User',
             optional: true

  has_many :messages,
           foreign_key: 'match_store_id',
           inverse_of: :match

  def to_h
    {
      id: id,
      updated_at: updated_at_int,
      time_since_update: "#{time_ago_in_words(updated_at)} ago",
      matched_user: matched_user.basic_hash,
      is_closed: closed_at.present?,
      closed_by: closed_by_id
    }
  end

  def updated_at_int
    updated_at.to_datetime.strftime('%Q')
  end
end
