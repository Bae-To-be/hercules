# frozen_string_literal: true

module Api
  module V1
    class MessagesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(matches)
        )
      end

      private

      def matches
        Match
          .find_by!(id: params[:match_id], user: current_user)
          .messages
          .order(created_at: :desc)
          .limit(limit)
          .offset(offset)
          .map(&:to_h)
      end
    end
  end
end
