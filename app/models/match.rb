# frozen_string_literal: true

class Match < ApplicationRecord
  self.primary_key = 'id'

  include ActionView::Helpers::DateHelper

  belongs_to :user,
             class_name: 'User'
  belongs_to :matched_user,
             class_name: 'User'

  has_many :messages,
           foreign_key: 'match_store_id',
           inverse_of: :match

  def to_h
    {
      id: id,
      time_since_creation: "#{time_ago_in_words(created_at)} ago",
      matched_user: matched_user.basic_hash
    }
  end
end
