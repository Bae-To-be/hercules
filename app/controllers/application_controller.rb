# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    if current_user.admin?
      redirect_to '/admin', alert: exception.message
    else
      redirect_to main_app.admin_login_path, alert: exception.message
    end
  end

  def current_user
    return if cookies.signed[:user_id].blank?

    AdminUser.find_by(id: cookies.signed[:user_id])
  end
end
