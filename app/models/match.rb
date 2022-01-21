# frozen_string_literal: true

class Match < ApplicationRecord
  include ActionView::Helpers::DateHelper

  belongs_to :user,
             class_name: 'User'
  belongs_to :matched_user,
             class_name: 'User'

  def to_h
    {
      id: id,
      time_since_creation: "#{time_ago_in_words(created_at)} ago",
      matched_user: matched_user.basic_hash
    }
  end
end
