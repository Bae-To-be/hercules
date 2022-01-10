# frozen_string_literal: true

module Api
  module V1
    class ReligionsController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            Religion.all.map(&:to_h)
          )
        )
      end
    end
  end
end
