# frozen_string_literal: true

module Api
  module V1
    class AuthController < BaseController
      skip_before_action :require_jwt, only: %i[verify refresh logout]

      def verify
        render_response(Auth::FindOrCreateUser.new(
          params[:auth_method],
          params[:token],
          params[:platform].presence || Auth::FindOrCreateUser::ANDROID
        ).run)
      end

      def refresh
        render_response(
          Auth::RefreshAccessToken
            .new(params[:refresh_token])
            .run
        )
      end

      def logout
        if params[:refresh_token].nil?
          render_response(ServiceResponse.bad_request(nil))
          return
        end

        RefreshToken
          .find_by_token(params[:refresh_token])
          &.destroy

        render_response(ServiceResponse.ok(nil))
      end

      def me
        render_response(
          ServiceResponse.ok(current_user.me_hash)
        )
      end
    end
  end
end
