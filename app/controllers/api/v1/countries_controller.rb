# frozen_string_literal: true

module Api
  module V1
    class CountriesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            ISO3166::Country.all.map(&:name)
          )
        )
      end
    end
  end
end
