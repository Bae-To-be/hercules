# frozen_string_literal: true

module Api
  module V1
    class UniversitiesController < BaseController
      def index
        render_response(ListRecords.new(
          University, 
          :search_by_name, 
          params[:query]
        ).run)
      end
    end
  end
end
