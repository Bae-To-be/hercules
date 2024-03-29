# frozen_string_literal: true

module Api
  module V1
    class UsersController < BaseController
      def update
        render_response(
          UpdateUser.new(current_user, user_params).run
        )
      end

      def show
        render_response(
          FindUserProfileService.new(current_user, params[:id]).run
        )
      end

      def delete_account
        current_user.destroy!
        render_response(ServiceResponse.ok(nil))
      end

      private

      def user_params
        params.permit(
          :birthday,
          :linkedin_url,
          :linkedin_public,
          :gender_id,
          :industry_id,
          :religion_id,
          :company_name,
          :work_title_name,
          :fcm_token,
          :height_in_cms,
          :bio,
          :status,
          :search_radius,
          :interested_age_lower,
          :interested_age_upper,
          :food_preference_id,
          :exercise_preference_id,
          :children_preference_id,
          :drinking_preference_id,
          :smoking_preference_id,
          language_ids: [],
          interested_gender_ids: [],
          hometown: [:country_name, :city_name],
          education: [:course_name, :year, :university_name],
          location: %i[lat lng country_code locality]
        )
      end
    end
  end
end
