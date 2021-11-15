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
          :interested_gender_ids,
          :industry_id,
          :company_name,
          :work_title_name,
          :university_name,
          :course_name,
          location: %i[lat lng country_code locality]
        )
      end
    end
  end
end
