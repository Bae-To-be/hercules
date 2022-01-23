# frozen_string_literal: true

module Api
  module V1
    class MessagesController < BaseController
      before_action :mark_as_read

      def index
        render_response(
          ServiceResponse.ok(messages)
        )
      end

      private

      def messages
        match
          .messages
          .includes(:author, :read_marks, match_store: [:source, :target])
          .order(created_at: :desc)
          .limit(limit)
          .offset(offset)
          .map(&:to_h)
      end

      def mark_as_read
        Message.mark_as_read!(
          Message.unread_by(current_user),
          for: current_user
        )
      end

      def match
        @match ||= Match
                     .find_by!(id: params[:match_id], user: current_user)
      end
    end
  end
end
