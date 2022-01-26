# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :match_store,
             inverse_of: :messages
  belongs_to :author,
             class_name: 'User'
  belongs_to :match,
             inverse_of: :messages,
             foreign_key: 'match_store_id'
  acts_as_readable on: :created_at

  def to_h
    {
      id: id,
      content: deleted? ? 'This message was deleted.' : content,
      author: author.basic_hash(include_picture: false),
      created_at: created_at.to_datetime.strftime('%Q'),
      updated_at: updated_at.to_datetime.strftime('%Q'),
      client_id: client_id,
      is_deleted: deleted?,
      unread_by: {
        match_store.source_id => read_marks.to_a.detect { |mark| mark.reader_id == match_store.source_id }.nil?,
        match_store.target_id => read_marks.to_a.detect { |mark| mark.reader_id == match_store.target_id }.nil?
      }
    }
  end

  def deleted?
    deleted_at.present?
  end
end
