# frozen_string_literal: true

class UserReportReason < ApplicationRecord
  has_many :user_reports, inverse_of: :user_report_reason

  def to_h
    {
      id: id,
      name: name
    }
  end
end
