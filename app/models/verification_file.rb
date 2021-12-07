# frozen_string_literal: true

class VerificationFile < ApplicationRecord
  has_paper_trail

  belongs_to :user, inverse_of: :verification_files

  has_one_attached :file
  delegate_missing_to :file

  enum file_type: { selfie: 0, identity: 1 }

  validates :file_type, uniqueness: { scope: :user_id }

  before_save :validate_blob

  def to_h
    {
      file_type: file_type,
      url: download_url
    }
  end

  def download_url
    if Rails.env.test?
      Rails
        .application
        .routes
        .url_helpers
        .rails_blob_path(file, only_path: true)
    else
      url
    end
  end

  private

  def validate_blob
    if file.attached?
      if file.blob.byte_size > 1_000_000_0
        file.purge
        errors.add(:base, 'File is too large')
        throw(:abort)
      end

      if identity?
        unless file.blob.content_type.include?('pdf') ||
               file.blob.content_type.starts_with?('image/')
          file.purge
          errors.add(:base, 'Only images and pdfs are allowed to be uploaded')
          throw(:abort)
        end
      elsif !file.blob.content_type.starts_with?('image/')
        file.purge
        errors.add(:base, 'Only images are allowed to be uploaded')
        throw(:abort)
      end
    else
      file.purge
      errors.add(:base, 'Creating verification file without an actual file not allowed')
      throw(:abort)
    end
  end
end
