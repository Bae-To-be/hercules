# frozen_string_literal: true

class ReportUserService
  def initialize(from, for_id, reason_id, comment)
    @from = from
    @for_id = for_id
    @reason_id = reason_id
    @comment = comment
  end

  def run
    if existing_report.present?
      existing_report.update!(
        user_report_reason: reason,
        comment: comment
      )
    else
      UserReport.create!(
        user_report_reason: reason,
        from: from,
        for: for_user,
        comment: comment
      )
    end

    ServiceResponse.ok(nil)
  end

  private

  attr_reader :from, :for_id, :comment, :reason_id

  def existing_report
    @existing_report ||= UserReport.find_by(from: from, for: for_user)
  end

  def for_user
    User.find(for_id)
  end

  def reason
    UserReportReason.find(reason_id)
  end
end
