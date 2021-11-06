# frozen_string_literal: true

module Api
  module V1
    class AuthController < BaseController
      skip_before_action :require_jwt, only: %i[verify]

      def verify
        render_response(Auth::FindOrCreateUser.new(
          params[:auth_method],
          params[:token]
        ).run)
      end

      def me
        render_response(
          ServiceResponse.ok(current_user.to_h)
        )
      end
    end
  end
end
