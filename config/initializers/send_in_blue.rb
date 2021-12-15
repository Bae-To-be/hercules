# frozen_string_literal: true

SibApiV3Sdk.configure do |config|
  # Configure API key authorization: api-key
  config.api_key['api-key'] = ENV.fetch('SEND_IN_BLUE_API_KEY')
end

SEND_IN_BLUE = SibApiV3Sdk::TransactionalEmailsApi.new
