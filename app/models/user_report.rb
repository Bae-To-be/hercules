# frozen_string_literal: true

class UserReport < ApplicationRecord
  belongs_to :from, class_name: 'User', inverse_of: :reports_filed
  belongs_to :for_user, class_name: 'User', inverse_of: :reports_received, foreign_key: 'for_id'
  belongs_to :user_report_reason, inverse_of: :user_reports

  validates :comment,
            length: { maximum: 500 },
            allow_nil: true

  validates :from_id, uniqueness: { scope: :for_id }

  def pretty_name
    "#{from_id} reported #{for_id}"
  end
end
