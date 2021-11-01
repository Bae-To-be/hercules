# frozen_string_literal: true

require 'open-uri'

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
        User.transaction do
          attach_image
          ServiceResponse
            .ok(formatted_data(new_user, true))
        end
      rescue Koala::Facebook::AuthenticationError
        ServiceResponse
          .unauthorized(INVALID_TOKEN)
      end
    end

    private

    attr_reader :token

    def formatted_data(user, is_new)
      {
        is_new_user: is_new,
        token: jwt_token(user)
      }
    end

    def jwt_token(user)
      Auth::Token.jwt_token(user)
    end

    def attach_image
      url = profile.dig(:picture, :data, :url)

      return if url.blank?

      # rubocop:disable Security/Open
      image_data = URI.open(url).read
      # rubocop:enable Security/Open
      data = ImageOptim.new.optimize_image_data(image_data)
      new_user.images.create!(profile_picture: true) do |image|
        image.file.attach(io: StringIO.new(data), filename: "fb_#{image.id}.jpeg")
      end
    end

    def existing_user
      @existing_user ||= User.find_by(email: profile[:email])
    end

    def new_user
      @new_user ||= User.create!(
        email: profile[:email],
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
