# frozen_string_literal: true

class UploadImage
  def initialize(path, user)
    @path = path
    @user = user
  end

  def run
    user.images.attach(path)
  rescue StandardError => e
    ServiceResponse.internal_server_error(e.message)
  end

  private

  attr_reader :path, :user
end
