# frozen_string_literal: true

PaperTrail.configure do |config|
  config.version_limit = 10
  config.track_associations = true
  config.association_reify_error_behaviour = :error
  PaperTrail.config.has_paper_trail_defaults = {
    on: %i[create update]
  }
end
