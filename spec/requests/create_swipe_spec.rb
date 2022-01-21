# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create Swipe', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { Auth::Token.jwt_token(user) }

  describe '/api/v1/swipes' do
    context 'when token is missing' do
      it 'returns 401' do
        post '/api/v1/swipes',
             headers: { 'HTTP_AUTHORIZATION' => '' }

        expect(response.status).to eq 401
      end
    end

    context 'when token is present' do
      context 'when trying to swipe yourself' do
        it 'returns 400' do
          post '/api/v1/swipes',
               params: { user_id: user.id, direction: 'left' },
               headers: { 'HTTP_AUTHORIZATION' => token }

          expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq('Validation failed: cannot swipe yourself')
          expect(response.status).to eq 400
        end
      end

      context 'when swiping a valid user' do
        let!(:another_user) { create(:user) }

        it 'returns 200' do
          post '/api/v1/swipes',
               params: { user_id: another_user.id, direction: 'right' },
               headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body, symbolize_names: true)[:data][:matched]).to eq false
        end
      end

      context 'when right swiping someone who has right swipes the user' do
        let!(:another_user) { create(:user) }

        before do
          create(:swipe, from: another_user, to: user, direction: 'right')
        end

        it 'returns 200' do
          post '/api/v1/swipes',
               params: { user_id: another_user.id, direction: 'right' },
               headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body, symbolize_names: true)[:data][:matched]).to eq true
        end
      end

      context 'when swiping a valid user with a wrong direction' do
        let!(:another_user) { create(:user) }

        it 'returns 400' do
          post '/api/v1/swipes',
               params: { user_id: another_user.id, direction: 'random' },
               headers: { 'HTTP_AUTHORIZATION' => token }

          expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq('incorrect swipe direction')
          expect(response.status).to eq 400
        end
      end
    end
  end
end
