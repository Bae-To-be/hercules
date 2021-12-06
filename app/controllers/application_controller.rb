# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/admin', alert: exception.message
  end

  def current_user
    return if cookies.signed[:user_id].blank?

    AdminUser.find_by(id: cookies.signed[:user_id])
  end
end
