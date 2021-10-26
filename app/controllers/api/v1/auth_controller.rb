# frozen_string_literal: true

module Api
  module V1
    class AuthController < BaseController
      skip_before_action :require_jwt

      def verify
        render_response(Auth::Facebook.new(
          params[:token]
        ).run)
      end
    end
  end
end
