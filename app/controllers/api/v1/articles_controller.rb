# frozen_string_literal: true

module Api
  module V1
    class ArticlesController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            Article.all.order(position: :asc).map(&:to_h)
          )
        )
      end
    end
  end
end
