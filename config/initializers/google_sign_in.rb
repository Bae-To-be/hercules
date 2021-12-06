# frozen_string_literal: true

Rails.application.configure do
  config.google_sign_in.client_id     = ENV.fetch('GOOGLE_ADMIN_CLIENT_ID')
  config.google_sign_in.client_secret = ENV.fetch('GOOGLE_ADMIN_CLIENT_SECRET')
end
