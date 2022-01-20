# frozen_string_literal: true

module Api
  module V1
    class LikesController < BaseController
      def sent
        render_response(
          ServiceResponse.ok(likes_sent)
        )
      end

      def received
        render_response(
          ServiceResponse.ok(likes_received)
        )
      end

      private

      def likes_sent
        Swipe.right.where(from_id: current_user.id).map(&:from_hash)
      end

      def likes_received
        Swipe.right.where(to_id: current_user.id).map(&:to_hash)
      end
    end
  end
end
