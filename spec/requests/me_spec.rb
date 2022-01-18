# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User profile', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { Auth::Token.jwt_token(user) }

  describe '/api/v1/me' do
    context 'when unauthorized' do
      it 'returns 401' do
        get '/api/v1/me',
            params: { image: nil },
            headers: { 'HTTP_AUTHORIZATION' => 'random_string' }

        expect(response.status).to eq 401
      end
    end

    context 'when valid token' do
      it 'returns 200' do
        get '/api/v1/me',
            params: { image: nil },
            headers: { 'HTTP_AUTHORIZATION' => token }

        expect(response.status).to eq 200
        expect(JSON.parse(response.body, symbolize_names: true)[:data]).to eq(user.me_hash)
      end
    end
  end
end
