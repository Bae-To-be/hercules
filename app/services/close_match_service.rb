# frozen_string_literal: true

class CloseMatchService
  def initialize(actor, match_id)
    @actor = actor
    @match_id = match_id
  end

  def run
    raise ActiveRecord::RecordNotFound, 'Match not found' unless [match_store.source_id, match_store.target_id].include?(actor.id)

    match_store.update!(
      closed_by: actor,
      closed_at: DateTime.now
    )

    NotifyUserJob.perform_later(
      match_store.other_user_id(actor),
      'match_closed',
      [{ match_id: match.id, updated_at: match.updated_at_int }]
    )

    ActionCable.server.broadcast("chat_#{match_id}", {
      event: 'match_closed',
      closed_by: actor.id
    })
    ServiceResponse.ok(nil)
  end

  private

  attr_reader :match_id, :actor

  def match_store
    @match_store = MatchStore.find(match_id)
  end
end
