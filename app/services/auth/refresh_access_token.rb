# frozen_string_literal: true

module Auth
  class RefreshAccessToken
    INVALID_TOKEN = 'Invalid refresh token passed'
    TOKEN_IS_REQUIRED = 'Refresh token is a required parameter'

    def initialize(refresh_token)
      @refresh_token = refresh_token
    end

    def run
      if refresh_token.nil?
        return ServiceResponse.bad_request(
          TOKEN_IS_REQUIRED
        )
      end

      token = RefreshToken.find_by(token: refresh_token)

      if token.nil?
        return ServiceResponse.unauthorized(
          INVALID_TOKEN
        )
      end

      ServiceResponse.ok(
        access_token: Auth::Token.jwt_token(token.user),
        expires_in: Auth::Token.expires_in
      )
    end

    private

    attr_reader :refresh_token
  end
end
