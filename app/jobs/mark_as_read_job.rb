# frozen_string_literal: true

class MarkAsReadJob < ApplicationJob
  queue_as :default

  def perform(user_id, message_ids)
    messages = Message.includes(:author, :read_marks, :match_store).where(id: message_ids)
    Message.mark_as_read!(
      messages,
      for: User.find(user_id)
    )
    messages.each do |message|
      ActionCable.server.broadcast("chat_#{message.match_store_id}", {
        event: 'message_updated',
        data: message.to_h
      })
    end
  end
end
