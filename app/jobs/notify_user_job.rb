# frozen_string_literal: true

class NotifyUserJob < ApplicationJob
  queue_as :default

  def perform(to_id, notification_type, notification_arguments = [])
    user = User.find(to_id)

    NotificationService.public_send(
      notification_type,
      user,
      *notification_arguments
    )
  end
end
