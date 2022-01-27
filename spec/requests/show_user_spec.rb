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
      context 'when valid user ID with no past action' do
        before do
          create(:user_report, for_user: user_to_find, from: user)
        end

        it 'returns 200' do
          get "/api/v1/users/#{user_to_find.id}",
              headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body, symbolize_names: true)[:data]).to eq(user_to_find.to_h.merge(
                                                                                  status: FindUserProfileService::STATUS_NONE,
                                                                                  is_reported: true,
                                                                                  match: nil
                                                                                ))
        end
      end

      context 'when valid user ID with left swipe from user' do
        before do
          create(:swipe, to: user_to_find, from: user, direction: :left)
        end

        it 'returns 200' do
          get "/api/v1/users/#{user_to_find.id}",
              headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body, symbolize_names: true)[:data]).to eq(user_to_find.to_h.merge(
                                                                                  status: FindUserProfileService::STATUS_REJECTED,
                                                                                  is_reported: false,
                                                                                  match: nil
                                                                                ))
        end
      end

      context 'when valid user ID with right swipe from user' do
        before do
          create(:swipe, to: user_to_find, from: user, direction: :right)
        end

        it 'returns 200' do
          get "/api/v1/users/#{user_to_find.id}",
              headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body, symbolize_names: true)[:data]).to eq(user_to_find.to_h.merge(
                                                                                  status: FindUserProfileService::STATUS_PENDING,
                                                                                  is_reported: false,
                                                                                  match: nil
                                                                                ))
        end
      end

      context 'when valid user ID matched with user' do
        let!(:match_store) { create(:match_store, source: user_to_find, target: user) }
        let(:match) { Match.find(match_store.id) }

        it 'returns 200' do
          get "/api/v1/users/#{user_to_find.id}",
              headers: { 'HTTP_AUTHORIZATION' => token }

          expect(response.status).to eq 200
          expect(JSON.parse(response.body, symbolize_names: true)[:data]).to eq(user_to_find.to_h.merge(
                                                                                  status: FindUserProfileService::STATUS_MATCHED,
                                                                                  is_reported: false,
                                                                                  match: match.to_h
                                                                                ))
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
