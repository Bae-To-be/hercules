# frozen_string_literal: true

module Api
  module V1
    class MatchesController < BaseController
      def index
        render_response(
          ListMatchesService.new(current_user, limit, offset).run
        )
      end
    end
  end
end
