# frozen_string_literal: true

module Api
  module V1
    class ImagesController < BaseController
      def create
        render_response(
          UploadImage.new(params[:image], current_user).run
        )
      end
    end
  end
end
