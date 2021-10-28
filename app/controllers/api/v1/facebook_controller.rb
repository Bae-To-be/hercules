# frozen_string_literal: true

module Api
  module V1
    class FacebookController < BaseController
      skip_before_action :require_jwt

      ID_PREFIX = 'bae_'

      def data_deletion
        data = parse_fb_signed_request(
          params['signed_request']
        )

        if data.nil?
          render json: { error: 'Invalid signed_request' },
                 status: :bad_request
          return
        end

        # Do data deletion stuff then
        user = User.find_by!(facebook_id: data['user_id'])
        user.destroy!

        render json: {
          url: "#{ENV.fetch('APP_HOST_URL')}/facebook/data_deletion?id=#{ID_PREFIX}#{user.id}",
          confirmation_code: ID_PREFIX + user.id.to_s
        }, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        Rails.logger.error(e)
        head :bad_request
      rescue StandardError => e
        Rails.logger.error(e)
        head :internal_server_error
      end

      def deletion_status
        id = params['id'].gsub(ID_PREFIX, '').to_i
        user = User.find_by(id: id)
        if user
          render plain: 'user still exists',
                 status: :ok
        else
          render plain: 'user details not found',
                 status: :not_found
        end
      end

      private

      def parse_fb_signed_request(signed_request)
        encoded_sig, payload = signed_request.split('.', 2)

        # Decode the data
        decoded_sig = Base64.urlsafe_decode64(encoded_sig)
        data = JSON.parse(Base64.urlsafe_decode64(payload))

        # Create the HMAC signature
        expected_sig = OpenSSL::HMAC.digest(
          'SHA256',
          ENV.fetch('FACEBOOK_APP_SECRET'),
          payload
        )

        return nil if decoded_sig != expected_sig

        data
      rescue StandardError
        nil
      end
    end
  end
end
