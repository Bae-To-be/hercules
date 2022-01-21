# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :match_store
  belongs_to :author,
             class_name: 'User'

  def to_h
    {
      id: id,
      content: content,
      author: author.basic_hash
    }
  end
end
