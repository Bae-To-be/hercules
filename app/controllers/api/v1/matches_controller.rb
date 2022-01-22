# frozen_string_literal: true

module Api
  module V1
    class MatchesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(matches)
        )
      end

      private

      def matches
        Match
          .where(user_id: current_user.id)
          .order(updated_at: :desc)
          .limit(limit)
          .offset(offset)
          .map(&:to_h)
      end
    end
  end
end
