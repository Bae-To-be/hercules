# frozen_string_literal: true

module Api
  module V1
    class ImagesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(current_user.images.order(position: :asc).map(&:to_h))
        )
      end

      def create
        render_response(
          UploadImage.new(params[:image], params[:position], current_user).run
        )
      end
    end
  end
end
