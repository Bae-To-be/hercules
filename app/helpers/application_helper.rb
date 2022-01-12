# frozen_string_literal: true

module ApplicationHelper
  def resource_url(blob)
    variant = blob.variant(resize_to_limit: [300, 300])
    Rails.application.routes.url_helpers.rails_blob_representation_path(
      variant.blob.signed_id, variant.variation.key, variant.blob.filename, only_path: true
    )
  end
end
