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
          .includes(:author, :read_marks, :match_store)
          .order(created_at: :desc)
          .limit(limit)
          .offset(offset)
          .map(&:to_h)
      end

      def mark_as_read
        Message.where(match_store_id: params[:match_id]).unread_by(current_user).in_batches do |unread_messages|
          MarkAsReadJob.perform_later(
            current_user.id,
            unread_messages.map(&:id)
          )
        end
      end

      def match
        @match ||= Match
                     .find_by!(id: params[:match_id], user: current_user)
      end
    end
  end
end
