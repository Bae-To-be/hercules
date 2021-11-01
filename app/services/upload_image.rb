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
         ActiveRecord::RecordNotSaved
    ServiceResponse
      .bad_request('invalid image')
  end

  private

  attr_reader :path, :user
end
