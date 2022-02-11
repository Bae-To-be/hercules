# frozen_string_literal: true

class Image < ApplicationRecord
  has_paper_trail

  belongs_to :user, inverse_of: :images

  has_one_attached :file
  delegate_missing_to :file

  validates :position, uniqueness: { scope: :user_id }

  before_save :validate_blob

  def to_h
    {
      position: position,
      url: download_url,
      id: id
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
      if file.blob.byte_size > 100_000
        file.purge
        errors.add(:base, 'Image is too large')
        throw(:abort)
      elsif !file.blob.content_type.starts_with?('image/')
        file.purge
        errors.add(:base, 'Only images are allowed to be uploaded')
        throw(:abort)
      end
    else
      file.purge
      errors.add(:base, 'Creating image without an actual file not allowed')
      throw(:abort)
    end
  end
end
