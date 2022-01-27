# frozen_string_literal: true

class UserReport < ApplicationRecord
  belongs_to :from, class_name: 'User', inverse_of: :reports_filed
  belongs_to :for, class_name: 'User', inverse_of: :reports_received
  belongs_to :user_report_reason, inverse_of: :user_reports
end
