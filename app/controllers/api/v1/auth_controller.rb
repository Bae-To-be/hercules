# frozen_string_literal: true

module Api
  module V1
    class AuthController < BaseController
      def verify
        response = Auth::Facebook.new(
          params[:token]
        ).run
        render json: response.body,
               status: response.code
      end
    end
  end
end
