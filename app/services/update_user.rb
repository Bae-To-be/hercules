# frozen_string_literal: true

class UpdateUser
  NO_VALID_ATTRIBUTES = 'no valid attributes'
  LOCATION_ATTRIBUTES_MISSING = 'missing lat and/or lng'
  class InvalidRequest < StandardError; end

  DIRECT_ATTRIBUTES = %i[
    birthday
    gender_id
    industry_id
    linkedin_url
    linkedin_public
    interested_gender_ids
    bio
    status
    religion_id
    height_in_cms
    language_ids
    food_preference_id
    children_preference_id
    drinking_preference_id
    smoking_preference_id
    search_radius
    interested_age_lower
    interested_age_upper
  ].freeze

  FUZZY_ATTRIBUTES = {
    company_name: Company,
    work_title_name: WorkTitle
  }.freeze

  def initialize(user, params)
    @user = user
    @params = params
  end

  def run
    User.transaction do
      return ServiceResponse.bad_request(NO_VALID_ATTRIBUTES) if params.empty?

      DIRECT_ATTRIBUTES.each do |direct_attribute|
        next if params[direct_attribute].nil?

        begin
          user.public_send(
            "#{direct_attribute}=",
            params[direct_attribute]
          )
        rescue ArgumentError => e
          return ServiceResponse.bad_request(
            e.message
          )
        end
      end

      unless params[:location].nil?
        unless params.dig(:location, :lat).present? &&
               params.dig(:location, :lng).present?
          return ServiceResponse.bad_request(
            LOCATION_ATTRIBUTES_MISSING
          )
        end

        user.country_code = params.dig(:location, :country_code) if params.dig(:location, :country_code).present?

        user.locality = params.dig(:location, :locality) if params.dig(:location, :locality).present?

        user.lat = params.dig(:location, :lat)
        user.lng = params.dig(:location, :lng)
      end

      unless params[:education].nil?
        user.educations = params[:education].map do |education_params|
          if education_params[:course_name].blank? ||
             education_params[:university_name].blank? ||
             education_params[:year].blank?

            raise InvalidRequest, 'Invalid education parameters'
          end

          Education.find_or_create_by!(
            user: user,
            course: Course.find_or_create_by!(name: titlize_if_not_upcase(education_params[:course_name])),
            university: University.find_or_create_by!(name: titlize_if_not_upcase(education_params[:university_name])),
            year: education_params[:year]
          )
        end
      end

      if params[:hometown].present?
        user.hometown_city_id = City.find_or_create_by!(name: params.dig(:hometown, :city_name)).id
        user.hometown_country = params.dig(:hometown, :country_name)
      end

      if params[:fcm_token].present?
        user.fcm[:token] = params[:fcm_token]
        user.fcm[:updated] = Time.now.utc
      end

      FUZZY_ATTRIBUTES.each do |key, model|
        next if params[key].blank?

        record = model.find_or_create_by!(name: titlize_if_not_upcase(params[key]))
        user.public_send(
          "#{model.name.underscore}=",
          record
        )
      end

      if user.birthday_changed?
        user.interested_age_lower = [(user.current_age - ENV.fetch('LOWER_AGE_BUFFER').to_i), 18].max if user.interested_age_lower.nil?
        user.interested_age_upper = user.current_age + ENV.fetch('UPPER_AGE_BUFFER').to_i if user.interested_age_upper.nil?
      end

      if user.verification_rejected?
        changes = []
        if !user.recent_verification.linkedin_approved? &&
           params[:linkedin_url].present?
          changes << VerificationRequest::LINKEDIN_URL
        end

        if !user.recent_verification.dob_approved? &&
           params[:birthday].present?
          changes << VerificationRequest::BIRTHDAY
        end

        if !user.recent_verification.education_approved? &&
           params[:education].present?
          changes << VerificationRequest::EDUCATION
        end

        if !user.recent_verification.work_details_approved? &&
           (params[:industry_id].present? ||
             params[:work_title_name].present? ||
             params[:company_name].present?)
          changes << VerificationRequest::WORK_INFO
        end

        user.recent_verification.user_update_submitted!(changes)
      end

      user.queue_verification!

      user.save!
    end
    ServiceResponse.ok(user.me_hash)
  end

  private

  attr_reader :user, :params

  def titlize_if_not_upcase(value)
    value == value.upcase ? value : value.titleize
  end
end
