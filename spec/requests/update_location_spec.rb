# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Update Location', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { Auth::Token.jwt_token(user) }

  describe '/api/v1/location' do
    context 'when unauthorized' do
      it 'returns 401' do
        post '/api/v1/location',
             params: {},
             headers: { 'HTTP_AUTHORIZATION' => 'random_string' }

        expect(response.status).to eq 401
      end
    end

    context 'when valid user' do
      context 'when missing parameter' do
        it 'returns 400' do
          post '/api/v1/location',
               params: { lat: 72.877426 },
               headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 400
          expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq('missing lat and/or lng')
        end
      end

      context 'when invalid parameter' do
        it 'returns 400' do
          post '/api/v1/location',
               params: { lat: 72.877426, lng: 'random_string' },
               headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 400
          expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq('Validation failed: Lng is not a number')
        end
      end

      context 'when params are valid' do
        it 'returns 200' do
          post '/api/v1/location',
               params: { lat: 72.877426, lng: 19.07609 },
               headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 200
        end
      end
    end
  end
end
