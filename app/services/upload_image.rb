# frozen_string_literal: true

class UploadImage
  def initialize(path, user)
    @path = path
    @user = user
  end

  def run
    ImageOptim.new.optimize_image!(path)
    image = user.images.create!(profile_picture: false) do |record|
       record.file.attach(path)
    end
    ServiceResponse.ok(image.to_h)
  rescue ActiveRecord::RecordInvalid, 
    ActiveRecord::RecordNotSaved => e
    ServiceResponse
      .bad_request('invalid image')
  rescue StandardError => e
    ServiceResponse.internal_server_error(e.message)
  end

  private

  attr_reader :path, :user
end
