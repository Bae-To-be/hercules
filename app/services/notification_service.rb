# frozen_string_literal: true

class NotificationService
  APPROVED_TITLE = 'Congratulations'
  APPROVED_BODY = 'Your account has been approved'
  REJECTED_TITLE = 'Oh No!'
  REJECTED_BODY = 'Looks like your application was rejected by our team'
  NEW_MESSAGE_TITLE = 'New Message'
  NEW_MESSAGE_BODY = 'You have received a new message from %{username}'
  NEW_MATCH_TITLE = 'New Match'
  NEW_MATCH_BODY = 'You have received a new match'

  # Events
  VERIFICATION_UPDATE = 'verification_update'
  NEW_MESSAGE = 'new_message'
  NEW_MATCH = 'new_match'

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

    def new_message(user, from, metadata)
      send_message(
        NEW_MESSAGE_TITLE,
        NEW_MESSAGE_BODY % from.name,
        user.fcm['token'],
        metadata.merge(event: NEW_MESSAGE)
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

    def send_message(title, body, token, metadata = {})
      message = Firebase::Admin::Messaging::Message.new(
        token: token,
        notification: Firebase::Admin::Messaging::Notification.new(
          title: title,
          body: body
        ),
        data: metadata
      )

      if token.nil?
        Rails.logger.warn("Token missing for: #{message}")
        return
      end
      FIREBASE_APP.messaging.send_one(message)
    end
  end
end
