# frozen_string_literal: true

module Api
  module V1
    class LocationsController < BaseController
      def create
        render_response(
          location_response
        )
      end

      def location_response
        unless params[:lat].present? &&
               params[:lng].present?

          return ServiceResponse.bad_request('missing lat and/or lng')
        end

        current_user.update!(
          lat: params[:lat],
          lng: params[:lng]
        )

        ServiceResponse.ok(nil)
      end
    end
  end
end
