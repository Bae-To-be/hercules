# frozen_string_literal: true

module Api
  module V1
    class IndustriesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            Industry.all.map(&:to_h)
          )
        )
      end
    end
  end
end
