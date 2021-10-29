# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :user

  has_one_attached :file
  delegate_missing_to :file

  before_save :validate_blob

  def to_h
    {
      url: download_url,
      profile_picture: profile_picture
    }
  end

  private

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

  def validate_blob
    if file.attached?
      if file.blob.byte_size > 1_000_000
        logo.purge
        errors.add(:base, 'Image is too large')
        throw(:abort)
      elsif !file.blob.content_type.starts_with?('image/')
        file.purge
        errors.add(:base, 'Only images are allowed to be uploaded')
        throw(:abort)
      end
    else
      errors.add(:base, 'Creating image without an actual file not allowed')
      throw(:abort)
    end
  end
end