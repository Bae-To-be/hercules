# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    before_action :require_jwt
    before_action do
      ActiveStorage::Current.host = "localhost:#{request.port}" if Rails.env.development?
    end

    private

    def render_response(response)
      render json: response.body,
             status: response.code
    end

    def current_user
      @current_user ||= User.find(decoded_token['id'])
    end

    def require_jwt
      head :unauthorized if !auth || decoded_token.blank?
    end

    def decoded_token
      @decoded_token ||= parsed_token
    end

    def parsed_token
      JWT.decode(
        auth.gsub!('Bearer ', ''),
        ENV.fetch('JWT_SECRET'),
        true,
        { algorithm: 'HS256' }
      )[0]
    rescue JWT::DecodeError
      ''
    end

    def auth
      @auth ||= request.headers['HTTP_AUTHORIZATION']
    end
  end
end
