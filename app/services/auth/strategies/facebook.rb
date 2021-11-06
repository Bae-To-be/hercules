# frozen_string_literal: true

require 'open-uri'

module Auth
  module Strategies
    class Facebook < Base
      GET_PROFILE_PARAMS = 'me?fields=name,email,picture.height(720).width(720),gender,birthday'

      def email_id
        profile[:email]
      end

      def main_attributes
        {
          email: profile[:email],
          birthday: profile[:birthday],
          name: profile[:name],
        }
      end

      def attributes_to_update
        {
          facebook_id: profile[:id]
        }
      end

      def image_url
        profile.dig(:picture, :data, :url)
      end
  
      private
  
      def client
        @client ||= Koala::Facebook::API.new(token)
      end
  
      def profile
        @profile ||= client
                       .get_object(GET_PROFILE_PARAMS)
                       .deep_symbolize_keys
      end
    end
  end
end
