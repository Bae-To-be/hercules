# frozen_string_literal: true

class VerificationSlackAlertService
  class << self
    def send(verification)
      return unless ENV.fetch('ADMIN_NOTIFICATION_ENABLED') == 'true'

      Faraday.post(
        ENV.fetch('SLACK_WEBHOOK_URL'),
        {
          blocks: [
            {
              type: 'section',
              text: {
                type: 'mrkdwn',
                text: '*New Verification Request*'
              }
            },
            {
              type: 'section',
              text: {
                type: 'mrkdwn',
                text: "<#{ENV.fetch('ADMIN_VERIFICATION_LINK')}/#{verification.id}|View Request>"
              },
              **image_section(verification)
            },
            {
              type: 'section',
              fields: [
                {
                  type: 'mrkdwn',
                  text: "*Email*\n#{verification.user_email}"
                },
                {
                  type: 'mrkdwn',
                  text: "*Submitted info*\n#{verification.user_kyc_info.to_json}"
                }
              ]
            }
          ]
        }.to_json,
        { 'Content-Type' => 'application/json' }
      )
    end

    def image_section(verification)
      if verification.user_selfie_verification.present?
        {
          accessory: {
            type: 'image',
            image_url: verification.user_selfie_verification&.download_url,
            alt_text: 'Selfie'
          }
        }
      else
        {}
      end
    end
  end
end
