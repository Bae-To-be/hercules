# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'List Messages', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { Auth::Token.jwt_token(user) }

  describe '/api/v1/me' do
    context 'when unauthorized' do
      it 'returns 401' do
        get '/api/v1/matches/1/messages',
            headers: { 'HTTP_AUTHORIZATION' => 'random_string' }

        expect(response.status).to eq 401
      end
    end

    context 'when valid token' do
      context 'when invalid match id' do
        it 'return 404' do
          get '/api/v1/matches/1/messages',
              headers: { 'HTTP_AUTHORIZATION' => token }
          expect(response.status).to eq 404
        end
      end

      context 'when valid match ID' do
        let!(:another_user) { create(:user) }

        context 'when user not in the match' do
          let!(:recipient) { create(:user) }
          let(:match_store) { create(:match_store, source: another_user, target: recipient) }
          let!(:message) { create(:message, match_store: match_store) }

          it 'return 404' do
            get "/api/v1/matches/#{match_store.id}/messages",
                headers: { 'HTTP_AUTHORIZATION' => token }
            expect(response.status).to eq 404
          end
        end

        context 'when user in the match' do
          let(:match_store) { create(:match_store, source: another_user, target: user) }
          let!(:message) { create(:message, match_store: match_store) }

          it 'returns the messages' do
            get "/api/v1/matches/#{match_store.id}/messages",
                headers: { 'HTTP_AUTHORIZATION' => token }
            expect(response.status).to eq 200
            expect(JSON.parse(response.body)['data'])
              .to eq([JSON.parse(message.to_h.to_json)])
          end
        end
      end
    end
  end
end
