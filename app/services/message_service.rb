# frozen_string_literal: true

class MessageService
  APPROVED_TITLE = 'Congratulations'
  APPROVED_BODY = 'Your account has been approved'
  REJECTED_TITLE = 'Oh No!'
  REJECTED_BODY = 'Looks like your application was rejected by our team'
  VERIFICATION_UPDATE = 'verification_update'

  class << self
    def approved(user)
      return if user.fcm['token'].blank? || Rails.env.test?

      send_message(
        APPROVED_TITLE,
        APPROVED_BODY,
        user.fcm['token'],
        VERIFICATION_UPDATE
      )
    end

    def rejected(user)
      return if user.fcm['token'].blank? || Rails.env.test?

      send_message(
        REJECTED_TITLE,
        REJECTED_BODY,
        user.fcm['token'],
        VERIFICATION_UPDATE
      )
    end

    def send_message(title, body, token, event)
      message = Firebase::Admin::Messaging::Message.new(
        token: token,
        notification: Firebase::Admin::Messaging::Notification.new(
          title: title,
          body: body
        ),
        data: {
          event: event
        }
      )
      FIREBASE_APP.messaging.send_one(message)
    end
  end
end
