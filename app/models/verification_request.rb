# frozen_string_literal: true

class VerificationRequest < ApplicationRecord
  VERIFICATION_UPDATE = 'verification_update'

  has_paper_trail

  belongs_to :user, inverse_of: :verification_requests

  enum status: {
    in_review: 0,
    approved: 1,
    rejected: 2
  }

  after_update :notify_user

  delegate :linkedin_url,
           :identity_verification_file,
           :selfie_verification_file,
           :images_for_verification,
           :kyc_info,
           to: :user,
           prefix: true

  private

  def notify_user
    event_data = {
      status: status,
      event: VERIFICATION_UPDATE
    }

    MessageService.approved(user, event_data) if approved?
    MessageService.rejected(user, event_data) if rejected?
  end
end
