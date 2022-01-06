# frozen_string_literal: true

module Api
  module V1
    class LanguagesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            Language.all.map(&:to_h)
          )
        )
      end
    end
  end
end
