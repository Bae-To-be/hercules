# frozen_string_literal: true

class UploadVerificationFile
  def initialize(path, user, file_type)
    @path = path
    @user = user
    @file_type = file_type
  end

  def run
    VerificationFile.transaction do
      existing = user.verification_files.find_by(file_type: file_type)
      file = if existing.present?
               existing.file.attach(path)
               existing.tap(&:save!)
             else
               user.verification_files.create!(file_type: file_type) do |record|
                 record.file.attach(path)
               end
             end
      if user.verification_rejected?
        if !user.recent_verification.selfie_approved? && file.selfie?
          user.recent_verification.user_update_submitted!(
            [VerificationRequest::SELFIE]
          )
        end
        if !user.recent_verification.identity_approved? && file.identity?
          user.recent_verification.user_update_submitted!(
            [VerificationRequest::IDENTITY]
          )
        end
      end
      user.queue_verification!(check_changes: false)
      ServiceResponse.ok(file.to_h)
    end
  rescue ActiveRecord::RecordInvalid,
         ActiveRecord::RecordNotSaved
    ServiceResponse
      .bad_request('invalid file')
  rescue ArgumentError => e
    ServiceResponse
      .bad_request(e.message)
  end

  private

  attr_reader :path, :user, :file_type
end
