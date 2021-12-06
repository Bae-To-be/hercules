# frozen_string_literal: true

module Admin
  class LoginController < ApplicationController
    def new; end

    def create
      user = authenticate_with_google
      if user
        cookies.signed[:user_id] = user.id
        redirect_to '/admin'
      else
        flash[:danger] = 'Invalid credentials'
        redirect_to admin_login_path
      end
    end

    private

    def authenticate_with_google
      id_token = flash[:google_sign_in]['id_token']
      if id_token
        user_info = GoogleSignIn::Identity.new(id_token)
        return if user_info.hosted_domain != 'baetobe.com'

        user = AdminUser.find_by(google_id: user_info.user_id)
        if user.nil?
          user = AdminUser.create!(
            email: user_info.email_address,
            google_id: user_info.user_id
          )
        else
          user.update!(email: user_info.email_address)
        end
        user
      elsif flash[:google_sign_in]['error']
        logger.error "Google authentication error: #{flash[:google_sign_in]['error']}"
        nil
      end
    end
  end
end
