# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :match_store,
             inverse_of: :messages
  belongs_to :author,
             class_name: 'User'
  belongs_to :match,
             inverse_of: :messages,
             foreign_key: 'match_store_id'

  def to_h
    {
      id: id,
      content: content,
      author: author.basic_hash(include_picture: false),
      created_at: created_at.to_datetime.strftime('%Q'),
      updated_at: updated_at.to_datetime.strftime('%Q')
    }
  end
end
