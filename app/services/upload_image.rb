# frozen_string_literal: true

class UploadImage
  def initialize(path, position, user)
    @path = path
    @position = position
    @user = user
  end

  def run
    return ServiceResponse.bad_request('position is required') if position.blank?

    ImageOptim.new.optimize_image!(path)
    existing = user.images.find_by(position: position)
    image = if existing.present?
              existing.file.attach(path)
              existing.tap(&:save!)
            else
              user.images.create!(position: position) do |record|
                record.file.attach(path)
              end
            end
    ServiceResponse.ok(image.to_h)
  rescue ActiveRecord::RecordInvalid,
         ActiveRecord::RecordNotSaved
    ServiceResponse
      .bad_request('invalid image or position')
  end

  private

  attr_reader :path, :user, :position
end
