# frozen_string_literal: true

class FindUserProfileService
  STATUS_REJECTED = 'rejected'
  STATUS_PENDING = 'pending'
  STATUS_MATCHED = 'matched'
  STATUS_NONE = 'none'

  def initialize(for_user, user_id)
    @for_user = for_user
    @user_id = user_id
  end

  def run
    raise ActiveRecord::RecordNotFound, 'User not found' if for_user_left_swiped?

    ServiceResponse.ok(
      User.find(user_id).to_h.merge(
        status: match_status,
        match_id: match&.id
      )
    )
  end

  private

  attr_reader :for_user, :user_id

  def for_user_left_swiped?
    for_user.swipes_received.left.exists?(from_id: user_id)
  end

  def match_status
    return STATUS_MATCHED if match.present?

    return STATUS_NONE if sent_swipe.blank?

    sent_swipe.right? ? STATUS_PENDING : STATUS_REJECTED
  end

  def sent_swipe
    @sent_swipe ||= for_user.swipes_performed.find_by(to_id: user_id)
  end

  def match
    @match ||= Match.find_by(
      user_id: for_user.id,
      matched_user_id: user_id
    )
  end
end
