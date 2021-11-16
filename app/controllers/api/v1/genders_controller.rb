# frozen_string_literal: true

module Api
  module V1
    class GendersController < BaseController
      def index
        render_response(
          ServiceResponse.ok(
            default: Gender.where(name: ['Male', 'Female']).map(&:to_h),
            all: Gender.all.order('name ASC').map(&:to_h)
          )
        )
      end
    end
  end
end
