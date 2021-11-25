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
    student
    interested_gender_ids
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

        user.public_send(
          "#{direct_attribute}=",
          params[direct_attribute]
        )
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
            course: Course.find_or_create_by!(name: education_params[:course_name]),
            university: University.find_or_create_by!(name: education_params[:university_name].titleize),
            year: education_params[:year]
          )
        end
      end

      FUZZY_ATTRIBUTES.each do |key, model|
        next if params[key].blank?

        record = model.find_or_create_by!(name: params[key].titleize)
        user.public_send(
          "#{model.name.underscore}=",
          record
        )
      end

      user.save!
    end
    ServiceResponse.ok(user.me_hash)
  end

  private

  attr_reader :user, :params
end
