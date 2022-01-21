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
          .includes(to: :images)
          .right
          .where.not(to_id: current_user.swipes_received.pluck(:from_id))
          .limit(limit)
          .offset(offset)
          .order(id: :desc)
          .map(&:from_hash)
      end

      def likes_received
        current_user
          .swipes_received
          .includes(from: :images)
          .right
          .where.not(from_id: current_user.swipes_performed.pluck(:to_id))
          .limit(limit)
          .offset(offset)
          .order(id: :desc)
          .map(&:to_hash)
      end
    end
  end
end
