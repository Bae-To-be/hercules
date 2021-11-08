# frozen_string_literal: true

module Api
  module V1
    class CoursesController < BaseController
      def index
        render_response(ListRecords.new(
          Course, 
          :search_by_name, 
          params[:query]
        ).run)
      end
    end
  end
end
