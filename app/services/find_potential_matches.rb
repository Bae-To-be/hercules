# frozen_string_literal: true

class FindPotentialMatches
  Result = Struct.new(:users, :filters)

  def initialize(user, limit)
    @user  = user
    @limit = limit
  end

  def run
    result = find_matches

    Rails.logger.info "Filter Performance for user ID: #{user.id}: #{result.filters}"


    result = formatted_result(result.users)
    if result.empty?
      NewRelic::Agent
        .increment_metric('Custom/User/NoPotentialMatches')
    end
    ServiceResponse.ok(result)
  end

  private

  attr_reader :user,
              :limit

  def formatted_result(ids)
    User
      .includes(:work_title, :images, :company, :industry, :gender)
      .find(ids).map(&:swipe_hash)
  end

  def find_matches
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
    # TODO: Remove users who don't have approved KYC
    bounds = Geokit::Bounds.from_point_and_radius(user, user.search_radius_value)
    query = User
              .active
              .where.not(id: user.id)
              .where.not(id: users_who_swiped_left)
              .where.not(id: swiped_user_ids)
              .in_bounds(bounds, inclusive: true)
              .between_age(user.interested_age_lower, user.interested_age_upper)
              .interested_in_genders([user.gender_id, Gender.find_by(name: 'All').id].compact)
              .exclude_company(user.company_id)
              .distinct

    return query.where(gender_id: user.interested_gender_ids) if user.interested_genders.detect { |gender| gender.name == 'All' }.nil?

    query
  end

  def users_who_swiped_left
    Swipe.where(to_id: user.id, direction: :left).select(:from_id)
  end

  def swiped_user_ids
    Swipe.where(from_id: user.id).select(:to_id)
  end

  def add_if_doesnt_exist(step_results, results)
    results.push(*step_results).uniq
  end
end
