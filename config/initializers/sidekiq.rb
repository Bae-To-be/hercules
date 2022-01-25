# frozen_string_literal: true

SIDEKIQ_REDIS_CONFIGURATION = {
  url: ENV[ENV['REDIS_PROVIDER']], # if one assumes that REDIS_PROVIDER indirection is reliably present
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } # we must trust Heroku and AWS here
}.freeze

Sidekiq.configure_server do |config|
  config.redis = SIDEKIQ_REDIS_CONFIGURATION
end

Sidekiq.configure_client do |config|
  config.redis = SIDEKIQ_REDIS_CONFIGURATION
end
