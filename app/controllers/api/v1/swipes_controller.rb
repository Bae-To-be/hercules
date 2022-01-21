# frozen_string_literal: true

module Api
  module V1
    class SwipesController < BaseController
      def create
        render_response(
          CreateSwipeService.new(
            actor: current_user,
            to_id: params[:user_id],
            direction: params[:direction]
          ).run
        )
      end
    end
  end
end
