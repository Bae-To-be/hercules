# frozen_string_literal: true

module Api
  module V1
    class ChildrenPreferencesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            ChildrenPreference.all.map(&:to_h)
          )
        )
      end
    end
  end
end
