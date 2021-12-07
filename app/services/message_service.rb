# frozen_string_literal: true

class MessageService
  APPROVED_TITLE = 'Congratulations'
  APPROVED_BODY = 'Your account has been approved'

  class << self
    def approved(user)
      return if user.fcm[:token].blank? || Rails.env.test?

      send_message(
        APPROVED_TITLE,
        APPROVED_TITLE,
        user.fcm[:token]
      )
    end

    def send_message(title, body, token)
      message = Firebase::Admin::Messaging::Message.new(
        token: token,
        notification: Firebase::Admin::Messaging::Notification.new(
          title: title,
          body: body
        )
      )
      FIREBASE_APP.messaging.send_one(message)
    end
  end
end
