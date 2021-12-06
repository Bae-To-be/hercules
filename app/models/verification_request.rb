# frozen_string_literal: true

class VerificationRequest < ApplicationRecord
  has_paper_trail

  belongs_to :user, inverse_of: :verification_requests

  enum status: {
    in_review: 0,
    approved: 1,
    rejected: 2
  }
end
