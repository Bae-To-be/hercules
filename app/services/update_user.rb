# frozen_string_literal: true

class UpdateUser
  NO_VALID_ATTRIBUTES = 'no valid attributes'
  LOCATION_ATTRIBUTES_MISSING = 'missing lat and/or lng'

  DIRECT_ATTRIBUTES = %i[
    birthday
    gender_id
    industry_id
    linkedin_url
    student
    interested_gender_ids
  ].freeze

  EXCLUDE_TITLIZE = %i[course_name].freeze

  FUZZY_ATTRIBUTES = {
    company_name: Company,
    work_title_name: WorkTitle,
    university_name: University,
    course_name: Course
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

      FUZZY_ATTRIBUTES.each do |key, model|
        next if params[key].blank?

        name = EXCLUDE_TITLIZE.include?(key) ? params[key] : params[key].titleize
        record = model.find_or_create_by!(name: name)
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
