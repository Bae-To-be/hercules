# frozen_string_literal: true

module Api
  class BaseController < ActionController::API
    before_action :require_jwt

    # Handlers for errors are searched from bottom to top
    rescue_from StandardError,
                with: :internal_server_error

    rescue_from ActiveRecord::RecordInvalid,
                ActiveRecord::RecordNotSaved,
                UpdateUser::InvalidRequest,
                Auth::FindOrCreateUser::InvalidProvider,
                with: :bad_request

    rescue_from ActiveRecord::RecordNotFound,
                with: :record_not_found

    private

    def bad_request(exception)
      render_response(
        ServiceResponse
          .bad_request(exception.message)
      )
    end

    def record_not_found(exception)
      render_response(
        ServiceResponse
          .not_found("#{exception.model} not found")
      )
    end

    def internal_server_error(exception)
      Rails.logger.error(exception)
      render_response(
        ServiceResponse
          .internal_server_error(exception.message)
      )
    end

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
      Auth::Token.parsed_token(auth)
    end

    def auth
      @auth ||= request.headers['HTTP_AUTHORIZATION']&.gsub('Bearer ', '')
    end

    def offset
      ((params[:page]&.to_i.presence || 1) - 1) * limit
    end

    def limit
      params[:limit]&.to_i.presence || 10
    end
  end
end
