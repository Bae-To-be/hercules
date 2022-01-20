# frozen_string_literal: true

module Api
  module V1
    class SwipesController < BaseController
      def create
        render_response(
          create_swipe_response
        )
      end

      def create_swipe_response
        existing = Swipe.find_by(
          from_id: current_user.id,
          to_id: params[:user_id]
        )
        if existing.present?
          existing.update(direction: params[:direction])
        else
          Swipe.create!(
            from_id: current_user.id,
            to_id: params[:user_id],
            direction: params[:direction]
          )
        end
        ServiceResponse.ok(nil)
      rescue ArgumentError
        ServiceResponse.bad_request(
          'incorrect swipe direction'
        )
      end
    end
  end
end
