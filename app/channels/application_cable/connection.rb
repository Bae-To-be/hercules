# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      return reject_unauthorized_connection if auth.nil?

      current_user = User.find_by(id: parsed_token['id'])

      current_user.presence || reject_unauthorized_connection
    end

    def parsed_token
      Auth::Token.parsed_token(auth)
    end

    def auth
      # TODO: Remove header authorization (ref: https://faqs.ably.com/is-it-secure-to-send-the-access_token-as-part-of-the-websocket-url-query-params)
      request.params['token'].presence ||
        request.headers['HTTP_AUTHORIZATION']&.gsub('Bearer ', '')
    end
  end
end
