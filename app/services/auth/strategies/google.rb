# frozen_string_literal: true

module Auth
  module Strategies
    class Google < Base
      def email_id
        parsed_token[:email]
      end

      def main_attributes
        {
          email: email_id,
          name: parsed_token[:name]
        }
      end

      def attributes_to_update
        {
          google_id: parsed_token[:sub]
        }
      end

      def image_url
        parsed_token[:picture]
      end

      private

      def parsed_token
        @parsed_token ||= token_validator.check(
          token,
          ENV.fetch('GOOGLE_WEB_CLIENT_ID'),
          ENV.fetch('GOOGLE_ANDROID_CLIENT_ID')
        ).deep_symbolize_keys
      end

      def token_validator
        @token_validator ||= GoogleIDToken::Validator.new
      end
    end
  end
end
