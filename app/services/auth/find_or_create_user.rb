# frozen_string_literal: true

module Auth
  class FindOrCreateUser
    class InvalidProvider < StandardError; end

    MISSING_AUTH_TOKEN = 'missing auth token'
    INVALID_TOKEN      = 'invalid token'
    ANDROID = 'android'

    def initialize(auth_method, token, platform)
      @strategy = "Auth::Strategies::#{auth_method.capitalize}".constantize.new(
        token,
        platform
      )
      @token = token
    rescue NameError
      raise InvalidProvider, "#{auth_method} is not a valid auth method"
    end

    def run
      if token.blank?
        return ServiceResponse
                 .bad_request(MISSING_AUTH_TOKEN)
      end

      if existing_user
        if ENV.fetch('TEST_USERS_ENABLED') == 'true' &&
           ENV.fetch('TEST_USER_EMAILS').split(',').include?(existing_user.email)

          existing_user.destroy!
          return new_user_response
        end
        update_existing_user
        return ServiceResponse
                 .ok(formatted_data(existing_user, false))
      end

      new_user_response
    rescue GoogleIDToken::ClientIDMismatchError,
           GoogleIDToken::AudienceMismatchError,
           GoogleIDToken::InvalidIssuerError,
           GoogleIDToken::SignatureError,
           GoogleIDToken::CertificateError,
           GoogleIDToken::ExpiredTokenError,
           Koala::Facebook::AuthenticationError
      ServiceResponse
        .unauthorized(INVALID_TOKEN)
    end

    private

    attr_reader :strategy, :token

    def new_user_response
      User.transaction do
        attach_image
        ServiceResponse
          .ok(formatted_data(new_user, true))
      end
    end

    def formatted_data(user, is_new)
      {
        is_new_user: is_new,
        refresh_token: user.refresh_tokens.create!.token,
        expires_in: Auth::Token.expires_in,
        access_token: jwt_token(user)
      }
    end

    def jwt_token(user)
      Auth::Token.jwt_token(user)
    end

    def existing_user
      @existing_user ||= User.find_by(email: strategy.email_id)
    end

    def new_user
      @new_user ||= User.create!(
        strategy.main_attributes
          .merge(strategy.attributes_to_update)
          .merge(last_logged_in: DateTime.now)
      )
    end

    def update_existing_user
      existing_user.update!(
        strategy.attributes_to_update
                .merge(last_logged_in: DateTime.now)
      )
    end

    def attach_image
      url = strategy.image_url

      return if url.blank?

      # rubocop:disable Security/Open
      image_data = URI.open(url).read
      # rubocop:enable Security/Open
      data = ImageOptim.new.optimize_image_data(image_data)
      new_user.images.create!(position: 0) do |image|
        image.file.attach(io: StringIO.new(data), filename: "fb_#{image.id}.jpeg")
      end
    end
  end
end
