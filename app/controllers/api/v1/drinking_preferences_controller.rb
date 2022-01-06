# frozen_string_literal: true

module Api
  module V1
    class DrinkingPreferencesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            DrinkingPreference.all.map(&:to_h)
          )
        )
      end
    end
  end
end
