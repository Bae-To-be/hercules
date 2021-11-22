# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      def update
        render_response(
          UpdateUser.new(current_user, user_params).run
        )
      end

      private

      def user_params
        params.permit(
          :birthday,
          :linkedin_url,
          :gender_id,
          :industry_id,
          :company_name,
          :work_title_name,
          :student,
          interested_gender_ids: [],
          location: %i[lat lng country_code locality]
        )
      end
    end
  end
end
