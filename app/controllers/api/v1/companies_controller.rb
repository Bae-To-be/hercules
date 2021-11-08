# frozen_string_literal: true

module Api
  module V1
    class CompaniesController < BaseController
      def index
        render_response(ListRecords.new(
          Company, 
          :search_by_name, 
          params[:query]
        ).run)
      end
    end
  end
end
