# frozen_string_literal: true

module Auth
  class Facebook
    GET_PROFILE_PARAMS = 'me?fields=name,email,picture.height(720).width(720),gender,birthday'
    MISSING_AUTH_TOKEN = 'missing auth token'
    INVALID_TOKEN      = 'invalid token'

    def initialize(token)
      @token = token
    end

    def run
      if token.blank?
        return ServiceResponse
                 .bad_request(MISSING_AUTH_TOKEN)
      end

      begin
        if existing_user
          return ServiceResponse
                   .ok(formatted_data(existing_user, false))
        end

        ServiceResponse
          .ok(formatted_data(new_user, true))
      rescue Koala::Facebook::AuthenticationError
        ServiceResponse
          .unauthorized(INVALID_TOKEN)
      rescue ActiveRecord::RecordInvalid => e
        ServiceResponse
          .bad_request(e.message)
      rescue StandardError => e
        ServiceResponse
          .internal_server_error(e.message)
      end
    end

    private

    attr_reader :token

    def formatted_data(user, is_new)
      {
        is_new_user: is_new,
        token: jwt_token(user),
        **user.to_h
      }
    end

    def jwt_token(user)
      JWT.encode(
        user.attributes.merge(exp: token_expiry),
        ENV.fetch('JWT_SECRET'),
        'HS256'
      )
    end

    def token_expiry
      Time.now.to_i +
        (ENV.fetch('JWT_EXPIRY_HOURS').to_i * 3600)
    end

    def existing_user
      @existing_user ||= User.find_by(email: profile[:email])
    end

    def new_user
      @new_user ||= User.create!(
        email: profile[:email],
        gender: profile[:gender],
        birthday: profile[:birthday],
        name: profile[:name],
        facebook_id: profile[:id]
      )
    end

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
