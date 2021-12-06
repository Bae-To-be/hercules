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
      user.queue_verification!
    end
    ServiceResponse.ok(file.to_h)
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
