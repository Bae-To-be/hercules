# frozen_string_literal: true

module Api
  module V1
    class ExercisePreferencesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            ExercisePreference.all.map(&:to_h)
          )
        )
      end
    end
  end
end
