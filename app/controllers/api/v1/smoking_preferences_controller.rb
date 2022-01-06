# frozen_string_literal: true

module Api
  module V1
    class SmokingPreferencesController < BaseController
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
