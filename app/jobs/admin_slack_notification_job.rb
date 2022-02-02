# frozen_string_literal: true

class AdminSlackNotificationJob < ApplicationJob
  queue_as :default

  def perform(verification_id)
    VerificationSlackAlertService.send(
      VerificationRequest.find(verification_id)
    )
  end
end
