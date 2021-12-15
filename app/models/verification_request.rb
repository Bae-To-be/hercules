# frozen_string_literal: true

class VerificationRequest < ApplicationRecord
  VERIFICATION_UPDATE = 'verification_update'

  has_paper_trail

  belongs_to :user, inverse_of: :verification_requests

  IN_REVIEW = 'in_review'
  APPROVED = 'approved'
  REJECTED = 'rejected'

  LINKEDIN_URL = 'linkedin_url'
  WORK_INFO = 'work_info'
  EDUCATION = 'education'
  BIRTHDAY = 'birthday'
  SELFIE = 'selfie'
  IDENTITY = 'identity'

  enum status: {
    IN_REVIEW => 0,
    APPROVED => 1,
    REJECTED => 2
  }

  before_update :notify_user, if: :status_changed?

  delegate :linkedin_url,
           :identity_verification_file,
           :selfie_verification_file,
           :images_for_verification,
           :kyc_info,
           to: :user,
           prefix: true

  def to_hash
    {
      status: status,
      linkedin_approved: linkedin_approved,
      work_details_approved: work_details_approved,
      education_approved: education_approved,
      dob_approved: dob_approved,
      selfie_approved: selfie_approved,
      identity_approved: identity_approved,
      fields_updated: user_updates,
      rejection_reason: rejection_reason
    }
  end

  def user_update_submitted!(keys)
    update!(user_updates: (user_updates + keys).uniq)
  end

  def all_fields_rectified?
    (linkedin_approved || user_updates.include?(LINKEDIN_URL)) &&
      (work_details_approved || user_updates.include?(WORK_INFO)) &&
      (education_approved || user_updates.include?(EDUCATION)) &&
      (dob_approved || user_updates.include?(BIRTHDAY)) &&
      (selfie_approved || user_updates.include?(SELFIE)) &&
      (identity_approved || user_updates.include?(IDENTITY))
  end

  private

  def notify_user
    return if Rails.env.test?

    event_data = {
      event: VERIFICATION_UPDATE
    }

    if approved?
      MessageService.approved(user, event_data)
      EmailService.new(
        to_name: 'gaurav',
        to_email: 'gaurav@baetobe.com',
        template_id: ENV.fetch('EMAIL_TEMPLATE_ID_VERIFICATION').to_i,
        dynamic_attributes: {
          status: status
        }
      ).send
    end
    return unless rejected?

    EmailService.new(
      to_name: 'gaurav',
      to_email: 'gaurav@baetobe.com',
      template_id: ENV.fetch('EMAIL_TEMPLATE_ID_VERIFICATION').to_i,
      dynamic_attributes: {
        status: status,
        fields: rejected_fields,
        rejection_reason: rejection_reason
      }
    ).send
    MessageService.rejected(user, event_data)
  end

  def rejected_fields
    %i[linkedin
       work_details
       education
       dob
       selfie
       identity]
      .reject { |field| public_send("#{field}_approved?") }
      .map { |field| field.to_s.titleize }
  end
end
