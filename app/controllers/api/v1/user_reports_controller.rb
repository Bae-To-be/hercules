# frozen_string_literal: true

module Api
  module V1
    class UserReportsController < BaseController
      def create
        render_response(ReportUserService.new(
          current_user,
          params[:user_id],
          params[:reason_id],
          params[:comment]
        ).run)
      end
    end
  end
end
