# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Get user profile', type: :request do
  let!(:user) { create(:user) }
  let!(:user_to_find) { create(:user) }
  let!(:token) { Auth::Token.jwt_token(user) }

  describe '/api/v1/me' do
    context 'when unauthorized' do
      it 'returns 401' do
        get "/api/v1/users/#{user.id}",
            headers: { 'HTTP_AUTHORIZATION' => 'random_string' }

        expect(response.status).to eq 401
      end
    end

    context 'when valid token' do
      context 'when valid user ID' do
        it 'returns 401' do
          get "/api/v1/users/#{user_to_find.id}",
              headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body, symbolize_names: true)[:data]).to eq(user_to_find.to_h)
        end
      end

      context 'when the other user has left swiped the current user' do
        before do
          create(:swipe, from: user_to_find, to: user, direction: :left)
        end

        it 'returns 404' do
          get "/api/v1/users/#{user_to_find.id}",
              headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 404
        end
      end

      context 'when invalid user ID' do
        it 'returns 404' do
          get '/api/v1/users/random',
              headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 404
        end
      end
    end
  end
end
