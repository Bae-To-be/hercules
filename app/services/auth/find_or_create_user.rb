# frozen_string_literal: true

module Auth
  class FindOrCreateUser
    class InvalidProvider < StandardError; end

    MISSING_AUTH_TOKEN = 'missing auth token'
    INVALID_TOKEN      = 'invalid token'

    def initialize(auth_method, token)
      @strategy = "Auth::Strategies::#{auth_method.capitalize}".constantize.new(
        token
      )
      @token = token
    rescue NameError
      raise InvalidProvider, "#{auth_method} is not a valid provider"
    end

    def run
      if token.blank?
        return ServiceResponse
                 .bad_request(MISSING_AUTH_TOKEN)
      end

      if existing_user
        update_existing_user
        return ServiceResponse
                 .ok(formatted_data(existing_user, false))
      end

      User.transaction do
        attach_image
        ServiceResponse
          .ok(formatted_data(new_user, true))
      end
    rescue GoogleIDToken::ClientIDMismatchError,
           GoogleIDToken::AudienceMismatchError,
           GoogleIDToken::InvalidIssuerError,
           GoogleIDToken::SignatureError,
           GoogleIDToken::CertificateError,
           Koala::Facebook::AuthenticationError
      ServiceResponse
        .unauthorized(INVALID_TOKEN)
    end

    private

    attr_reader :strategy, :token

    def formatted_data(user, is_new)
      {
        is_new_user: is_new,
        token: jwt_token(user)
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
      )
    end

    def update_existing_user
      existing_user.update!(strategy.attributes_to_update)
    end

    def attach_image
      url = strategy.image_url

      return if url.blank?

      # rubocop:disable Security/Open
      image_data = URI.open(url).read
      # rubocop:enable Security/Open
      data = ImageOptim.new.optimize_image_data(image_data)
      new_user.images.create!(profile_picture: true) do |image|
        image.file.attach(io: StringIO.new(data), filename: "fb_#{image.id}.jpeg")
      end
    end
  end
end
