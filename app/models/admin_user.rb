# frozen_string_literal: true

class AdminUser < ApplicationRecord
  validates :email, uniqueness: true
  validates :google_id, uniqueness: true

  enum role: { no_role: 0, admin: 1, kyc_agent: 2 }
end
