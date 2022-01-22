# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  def subscribed
    reject if params[:match_id].blank?

    reject if Match.find_by(id: params[:match_id], user: current_user).blank?

    stream_from "chat_#{params[:match_id]}", coder: ActiveSupport::JSON
  end

  def unsubscribed; end

  def send_message(data)
    unless data.keys.include?('text')
      Rails.logger.error("received invalid payload: #{data}")
      return
    end

    begin
      match = MatchStore.find(params[:match_id])
      message = Message.create(
        match_store: match,
        author: current_user,
        content: data['text']
      )
      match.update!(updated_at: DateTime.now)
      ActionCable.server.broadcast("chat_#{params[:match_id]}", {
        event: 'new_message',
        data: message.to_h
      })
    rescue StandardError => e
      Rails.logger.error("Could not send message: #{e}")
    end
  end
end
