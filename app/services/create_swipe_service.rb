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
      existing = Swipe.find_by(
        from_id: actor.id,
        to_id: to_id
      )
      if existing.present?
        existing.update(direction: direction)
      else
        Swipe.create!(
          from_id: actor.id,
          to_id: to_id,
          direction: direction
        )
      end
      if direction == 'right' &&
         actor.swipes_received.right.exists?(from_id: to_id)

        matched = true
        MatchStore.create!(
          source: actor,
          target_id: to_id
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
