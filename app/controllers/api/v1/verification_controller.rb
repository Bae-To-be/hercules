# frozen_string_literal: true

module Api
  module V1
    class VerificationController < BaseController
      def me
        render_response(
          ServiceResponse.ok(current_user.recent_verification&.to_hash)
        )
      end
    end
  end
end
