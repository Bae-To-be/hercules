# frozen_string_literal: true

class NotificationService
  APPROVED_TITLE = 'Congratulations'
  APPROVED_BODY = 'Your account has been approved'
  REJECTED_TITLE = 'Oh No!'
  REJECTED_BODY = 'Looks like your application was rejected by our team'
  NEW_MESSAGE_TITLE = 'New Message'
  NEW_MESSAGE_BODY = 'You have received a new message from %<username>s'
  NEW_LIKE_TITLE = 'New Like'
  NEW_LIKE_BODY = 'You have received a new like'
  NEW_MATCH_TITLE = 'New Match'
  NEW_MATCH_BODY = 'You have received a new match'

  # Events
  VERIFICATION_UPDATE = 'verification_update'
  NEW_MESSAGE = 'new_message'
  NEW_MATCH = 'new_match'
  NEW_LIKE = 'new_like'
  LEFT_SWIPED = 'left_swiped'
  MATCH_CLOSED = 'match_closed'

  class << self
    def approved(user)
      send_message(
        APPROVED_TITLE,
        APPROVED_BODY,
        user.fcm['token'],
        { event: VERIFICATION_UPDATE }
      )
    end

    def rejected(user)
      send_message(
        REJECTED_TITLE,
        REJECTED_BODY,
        user.fcm['token'],
        { event: VERIFICATION_UPDATE }
      )
    end

    def new_message(user, from_name, metadata)
      send_message(
        NEW_MESSAGE_TITLE,
        format(NEW_MESSAGE_BODY, username: from_name),
        user.fcm['token'],
        metadata.merge(event: NEW_MESSAGE)
      )
    end

    def new_like(user, metadata)
      send_message(
        NEW_LIKE_TITLE,
        NEW_LIKE_BODY,
        user.fcm['token'],
        metadata.merge(event: NEW_LIKE)
      )
    end

    def left_swiped(user, metadata)
      send_data_message(
        user.fcm['token'],
        metadata.merge(event: LEFT_SWIPED)
      )
    end

    def match_closed(user, metadata)
      send_data_message(
        user.fcm['token'],
        metadata.merge(event: MATCH_CLOSED)
      )
    end

    def new_match(user, metadata)
      send_message(
        NEW_MATCH_TITLE,
        NEW_MATCH_BODY,
        user.fcm['token'],
        metadata.merge(event: NEW_MATCH)
      )
    end

    def send_data_message(data, token)
      message = Firebase::Admin::Messaging::Message.new(
        token: token,
        data: Stringify.hash_values(data)
      )

      if token.nil?
        Rails.logger.warn("Token missing for: #{message.inspect}")
        return
      end
      FIREBASE_APP.messaging.send_one(message)
    end

    def send_message(title, body, token, metadata = {})
      message = Firebase::Admin::Messaging::Message.new(
        token: token,
        notification: Firebase::Admin::Messaging::Notification.new(
          title: title,
          body: body
        ),
        data: Stringify.hash_values(metadata)
      )

      if token.nil?
        Rails.logger.warn("Token missing for: #{message.inspect}")
        return
      end
      FIREBASE_APP.messaging.send_one(message)
    end
  end
end
