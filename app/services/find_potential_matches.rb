# frozen_string_literal: true

# TODO: Fix the education lookup logic
class FindPotentialMatches
  Result = Struct.new(:users, :filters)

  def initialize(user, limit)
    @user  = user
    @limit = limit
  end

  def run
    result = find_matches_for_professional

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
      .includes(:work_title, :company, :course, :industry, :gender, :university)
      .find(ids).map(&:to_h)
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
    # TODO: Accommodate ALL gender preference from both sides
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
    :exclude_company
  end

  def institute_id
    user.company_id
  end
end
