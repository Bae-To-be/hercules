# frozen_string_literal: true

module Api
  module V1
    class VerificationFilesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(current_user.verification_files.map(&:to_h))
        )
      end

      def create
        render_response(
          UploadVerificationFile.new(params[:file], current_user, params[:file_type]).run
        )
      end
    end
  end
end
