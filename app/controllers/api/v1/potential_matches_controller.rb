# frozen_string_literal: true

module Api
  module V1
    class PotentialMatchesController < BaseController
      def index
        render_response(
          FindPotentialMatches.new(
            current_user,
            params[:limit]&.to_i.presence || 10
          ).run
        )
      end
    end
  end
end
