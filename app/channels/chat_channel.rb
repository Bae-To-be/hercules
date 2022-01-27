# frozen_string_literal: true

class ChatChannel < ApplicationCable::Channel
  after_subscribe :connection_monitor
  CONNECTION_TIMEOUT = 10.seconds
  CONNECTION_PING_INTERVAL = 5.seconds

  periodically every: CONNECTION_PING_INTERVAL do
    @driver&.ping
    connection.disconnect if Time.zone.now - @_last_request_at > @_timeout
  end

  def connection_monitor
    @_last_request_at ||= Time.zone.now
    @_timeout = CONNECTION_TIMEOUT
    @driver = connection.instance_variable_get('@websocket').possible?&.instance_variable_get('@driver')
    @driver.on(:pong) { @_last_request_at = Time.zone.now }
  end

  def subscribed
    reject if params[:match_id].blank?

    reject if Match.find_by(id: params[:match_id], user: current_user).blank?

    stream_from "chat_#{params[:match_id]}", coder: ActiveSupport::JSON
  end

  def unsubscribed; end

  def mark_as_read(data)
    unless data.keys.include?('message_id')
      Rails.logger.error("received invalid payload: #{data}")
      return
    end
    message = Message.find(data['message_id'])
    message.mark_as_read!(for: current_user)

    ActionCable.server.broadcast("chat_#{params[:match_id]}", {
      event: 'message_updated',
      data: message.to_h
    })
  end

  def delete_message(data)
    unless data.keys.include?('message_id')
      Rails.logger.error("received invalid payload: #{data}")
      return
    end

    message = Message.find_by!(id: data['message_id'], author: current_user)
    message.update(deleted_at: DateTime.now)
    ActionCable.server.broadcast("chat_#{params[:match_id]}", {
      event: 'message_updated',
      data: message.to_h
    })
  end

  def send_message(data)
    unless data.keys.include?('text')
      Rails.logger.error("received invalid payload: #{data}")
      return
    end

    begin
      match = MatchStore.find(params[:match_id])
      attributes = {
        match_store: match,
        author: current_user,
        content: data['text'],
        client_id: data['client_id'].presence
      }.compact

      message = Message.create(attributes)
      message.mark_as_read! for: current_user
      match.update!(updated_at: DateTime.now)

      begin
        NotifyUserJob.perform_later(
          match.other_user_id(current_user),
          'new_message',
          [current_user.name, { match_id: match.id, updated_at: match.updated_at_int }]
        )
      rescue StandardError => e
        Rails.logger.error("Failed to notify user: #{e}")
      end

      ActionCable.server.broadcast("chat_#{params[:match_id]}", {
        event: 'new_message',
        data: message.to_h
      })
    rescue StandardError => e
      Rails.logger.error("Could not send message: #{e}")
    end
  end
end
