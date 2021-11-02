# frozen_string_literal: true

class FindPotentialMatches
  Result = Struct.new(:users, :filters)

  def initialize(user, limit)
    @user  = user
    @limit = limit
  end

  def run
    result = if user.student?
               find_matches_for_student
             else
               find_matches_for_professional
             end

    Rails.logger.info "Filter Performance for user ID: #{user.id}: #{result.filters}"

    ServiceResponse.ok(
      formatted_result(result.users)
    )
  end

  private

  attr_reader :user,
              :limit

  def formatted_result(ids)
    User
      .includes(:work_title, :company, :course, :industry, :profile_picture, :gender, :university)
      .find(ids).map(&:to_h)
  end

  def find_matches_for_student
    filters = {}
    results = users_in_same_course.pluck(:id)

    filters[:same_course] = results.size

    return Result.new(results, filters) if results.size >= limit

    related_courses = courses_matching_user.includes(:related_courses).flat_map(&:related_course_ids)
    if related_courses.any?
      step_results = base_query
                       .where(course_id: related_courses)
                       .limit(limit).pluck(:id)

      filters[:similar_courses] = step_results.size
      add_if_doesnt_exist(step_results, results)

      return Result.new(results, filters) if results.size >= limit
    end

    results += base_query.limit(limit).pluck(:id)

    Result.new(results, filters)
  end

  def find_matches_for_professional
    filters = {}
    results = users_in_same_designation.pluck(:id)

    filters[:same_designation] = results.size

    return Result.new(results, filters) if results.size >= limit

    related_work_titles = work_titles_matching_user.includes(:related_work_titles).flat_map(&:related_work_title_ids)
    if related_work_titles.any?
      step_results = base_query
                       .where(work_title_id: related_work_titles)
                       .limit(limit).pluck(:id)

      filters[:similar_designations] = step_results.size
      add_if_doesnt_exist(step_results, results)

      return Result.new(results, filters) if results.size >= limit
    end

    step_results = users_in_same_industry.pluck(:id)
    filters[:same_industry] = step_results.size
    add_if_doesnt_exist(step_results, results)

    return Result.new(results, filters) if results.size >= limit

    related_industries = user.industry.related_industry_ids
    if related_industries.any?
      step_results = base_query
                       .where(industry_id: user.industry.related_industry_ids)
                       .limit(limit).pluck(:id)

      filters[:similar_industries] = step_results.size
      add_if_doesnt_exist(step_results, results)

      return Result.new(results, filters) if results.size >= limit
    end

    step_results = base_query.limit(limit).pluck(:id)
    filters[:base_filter] = results.size
    add_if_doesnt_exist(step_results, results)

    Result.new(results, filters)
  end

  def users_in_same_course
    base_query
      .where(course_id: courses_matching_user.pluck(:id))
      .limit(limit)
  end

  def users_in_same_designation
    base_query
      .where(work_title_id: work_titles_matching_user.pluck(:id))
      .limit(limit)
  end

  def users_in_same_industry
    base_query
      .where(industry_id: user.industry_id)
      .limit(limit)
  end

  def courses_matching_user
    Course.search_by_name(user.course.name)
  end

  def work_titles_matching_user
    WorkTitle.search_by_name(user.work_title.name)
  end

  def base_query
    User
      .where.not(id: [user.id, *swiped_user_ids])
      .where(gender_id: user.interested_gender_ids)
      .in_range(0..user.search_radius_value * 1000, origin: user)
      .between_age(user.interested_age_lower, user.interested_age_upper)
      .interested_in_gender(user.gender_id)
      .public_send(institute_query, institute_id)
      .distinct
  end

  def swiped_user_ids
    Swipe.where(from_id: user.id).pluck(:to_id)
  end

  def add_if_doesnt_exist(step_results, results)
    results.push(*step_results).uniq
  end

  def institute_query
    user.student? ? :exclude_university : :exclude_company
  end

  def institute_id
    user.student? ? user.university_id : user.company_id
  end
end
