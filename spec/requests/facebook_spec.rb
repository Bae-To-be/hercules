# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Facebook Endpoints', type: :request do
  describe 'data_deletion' do
    context 'when user existed' do
      let(:user) { create(:user, facebook_id: '12345') }
      let(:payload) { Base64.urlsafe_encode64({ user_id: user.facebook_id }.to_json) }
      let(:encoded_sig) { Base64.urlsafe_encode64(OpenSSL::HMAC.digest('SHA256', ENV.fetch('FACEBOOK_APP_SECRET'), payload)) }
      let(:signed_request) { "#{encoded_sig}.#{payload}" }

      it 'returns the endpoint to call for deletion status check' do
        post '/api/v1/facebook/data_deletion',
             params: { signed_request: signed_request }
        expect(response.status).to eq 200
        expect(JSON.parse(response.body, symbolize_names: true)).to eq({
          url: "#{ENV.fetch('APP_HOST_URL')}/facebook/data_deletion?id=#{Api::V1::FacebookController::ID_PREFIX}#{user.id}",
          confirmation_code: Api::V1::FacebookController::ID_PREFIX + user.id.to_s
        })
      end
    end

    context 'when user did not exist' do
      let(:payload) { Base64.urlsafe_encode64({ user_id: 'randomew_string' }.to_json) }
      let(:encoded_sig) { Base64.urlsafe_encode64(OpenSSL::HMAC.digest('SHA256', ENV.fetch('FACEBOOK_APP_SECRET'), payload)) }
      let(:signed_request) { "#{encoded_sig}.#{payload}" }

      it 'returns the endpoint to call for deletion status check' do
        post '/api/v1/facebook/data_deletion',
             params: { signed_request: signed_request }
        expect(response.status).to eq 400
      end
    end

    context 'when invalid signed request' do
      it 'returns bad request' do
        post '/api/v1/facebook/data_deletion',
             params: { signed_request: 'random_string.random_data' }
        expect(response.status).to eq 400
        expect(JSON.parse(response.body)['error']).to eq 'Invalid signed_request'
      end
    end
  end

  describe 'deletion_status' do
    context 'when user exists' do
      let(:user) { create(:user) }

      it 'returns user still exists' do
        get '/facebook/data_deletion',
            params: { id: Api::V1::FacebookController::ID_PREFIX + user.id.to_s }

        expect(response.status).to eq 200
        expect(response.body).to eq 'user still exists'
      end
    end

    context 'when user does not exist' do
      it 'returns user details not found' do
        get '/facebook/data_deletion',
            params: { id: 'old_user_id' }

        expect(response.status).to eq 404
        expect(response.body).to eq 'user details not found'
      end
    end
  end
end
