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
        current_user
          .swipes_performed
          .right
          .limit(limit)
          .offset(offset)
          .order(id: :desc)
          .map(&:from_hash)
      end

      def likes_received
        current_user
          .swipes_received
          .right
          .limit(limit)
          .offset(offset)
          .order(id: :desc)
          .map(&:to_hash)
      end

      def offset
        ((params[:page]&.to_i.presence || 1) - 1) * limit
      end

      def limit
        params[:limit]&.to_i.presence || 10
      end
    end
  end
end
