# frozen_string_literal: true

module Api
  module V1
    class CitiesController < BaseController
      def index
        render_response(ListRecords.new(
          City,
          :search_by_name,
          params[:query]
        ).run)
      end
    end
  end
end
