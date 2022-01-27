# frozen_string_literal: true

module Api
  module V1
    class MatchesController < BaseController
      def index
        render_response(
          ListMatchesService.new(current_user, limit, offset).run
        )
      end

      def close
        render_response(
          CloseMatchService.new(current_user, params[:id]).run
        )
      end
    end
  end
end
