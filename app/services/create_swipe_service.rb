# frozen_string_literal: true

class CreateSwipeService
  def initialize(actor:, to_id:, direction:)
    @actor = actor
    @to_id = to_id
    @direction = direction
  end

  def run
    Swipe.transaction do
      matched = false
      swipe = Swipe.find_by(
        from_id: actor.id,
        to_id: to_id
      )
      if swipe.present?
        swipe.update(direction: direction)
      else
        swipe = Swipe.create!(
          from_id: actor.id,
          to_id: to_id,
          direction: direction
        )
      end
      if direction == 'right'
        if actor.swipes_received.right.exists?(from_id: to_id)
          matched = true

          match = MatchStore.create!(
            source: actor,
            target_id: to_id
          )

          NotifyUserJob.perform_later(
            match.target_id,
            'new_match',
            [{ match: Match
                        .find_by(user: match.target, id: match.id)
                        .to_h.merge(unread_count: 0).to_json }]
          )
        else
          NotifyUserJob.perform_later(
            to_id,
            'new_like',
            [{ like: swipe.to_hash.to_json }]
          )
        end
      elsif actor.swipes_received.right.exists?(from_id: to_id)
        NotifyUserJob.perform_later(
          to_id,
          'left_swiped',
          [{ like_id: swipe.id }]
        )
      end

      ServiceResponse.ok(matched: matched)
    end
  rescue ArgumentError
    ServiceResponse.bad_request(
      'incorrect swipe direction'
    )
  end

  private

  attr_reader :actor, :to_id, :direction
end
