# frozen_string_literal: true

module Api
  module V1
    class GendersController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            Gender.all.map(&:to_h)
          )
        )
      end
    end
  end
end
