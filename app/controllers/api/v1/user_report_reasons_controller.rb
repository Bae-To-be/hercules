# frozen_string_literal: true

module Api
  module V1
    class UserReportReasonsController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            UserReportReason.all.map(&:to_h)
          )
        )
      end
    end
  end
end
