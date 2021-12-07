# frozen_string_literal: true

class VerificationRequest < ApplicationRecord
  has_paper_trail

  belongs_to :user, inverse_of: :verification_requests

  enum status: {
    in_review: 0,
    approved: 1,
    rejected: 2
  }

  delegate :linkedin_url,
           :identity_verification_file,
           :selfie_verification_file,
           :images_for_verification,
           :kyc_info,
           to: :user,
           prefix: true
end
