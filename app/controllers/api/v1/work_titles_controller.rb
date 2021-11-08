# frozen_string_literal: true

module Api
  module V1
    class WorkTitlesController < BaseController
      def index
        render_response(ListRecords.new(
          WorkTitle,
          :search_by_name,
          params[:query]
        ).run)
      end
    end
  end
end
