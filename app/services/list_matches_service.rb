# frozen_string_literal: true

class ListMatchesService
  def initialize(user, limit, offset)
    @user = user
    @limit = limit
    @offset = offset
  end

  def run
    ServiceResponse.ok(
      matches.map do |match|
        match.to_h.merge(
          unread_count: unread_counts[match.id] || 0
        )
      end
    )
  end

  private

  attr_reader :user, :limit, :offset

  def unread_counts
    @unread_counts ||= Message
                         .where(match_store_id: matches.map(&:id))
                         .unread_by(user)
                         .group(:match_store_id)
                         .select('count(messages.id) as count, match_store_id')
                         .map { |result| [result.match_store_id, result.count] }
                         .to_h
  end

  def matches
    @matches ||= Match
                   .includes(matched_user: :images)
                   .where(user_id: user.id)
                   .order(updated_at: :desc)
                   .limit(limit)
                   .offset(offset)
  end
end
