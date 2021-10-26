# frozen_string_literal: true

Koala.configure do |config|
  config.app_id = ENV.fetch('FACEBOOK_APP_ID')
  config.app_secret = ENV.fetch('FACEBOOK_APP_SECRET')
end
