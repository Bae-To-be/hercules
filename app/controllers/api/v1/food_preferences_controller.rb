# frozen_string_literal: true

module Api
  module V1
    class FoodPreferencesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            FoodPreference.all.map(&:to_h)
          )
        )
      end
    end
  end
end
