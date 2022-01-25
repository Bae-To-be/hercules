# frozen_string_literal: true

class AdminConstraint
  def matches?(request)
    request.cookies['user_id'].present?
  end
end
