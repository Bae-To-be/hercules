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
          :linkedin_public,
          :gender_id,
          :industry_id,
          :company_name,
          :work_title_name,
          :fcm_token,
          interested_gender_ids: [],
          education: [:course_name, :year, :university_name],
          location: %i[lat lng country_code locality]
        )
      end
    end
  end
end
