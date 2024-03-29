# frozen_string_literal: true

module Auth
  class Token
    class << self
      def jwt_token(user)
        JWT.encode(
          { id: user.id, exp: token_expiry },
          ENV.fetch('JWT_SECRET'),
          'HS256'
        )
      end

      def parsed_token(token)
        JWT.decode(
          token,
          ENV.fetch('JWT_SECRET'),
          true,
          { algorithm: 'HS256' }
        )[0]
      rescue JWT::DecodeError
        ''
      end

      def expires_in
        (ENV.fetch('JWT_EXPIRY_MINUTES').to_i * 60)
      end

      private

      def token_expiry
        Time.now.to_i +
          expires_in
      end
    end
  end
end
