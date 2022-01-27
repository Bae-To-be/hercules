# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Report User', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { Auth::Token.jwt_token(user) }

  describe '/api/v1/user_reports' do
    context 'when unauthorized' do
      it 'returns 401' do
        post '/api/v1/user_reports',
             headers: { 'HTTP_AUTHORIZATION' => 'random_string' }

        expect(response.status).to eq 401
      end
    end

    context 'when valid token' do
      let(:for_user) { create(:user) }
      let(:reason) { create(:user_report_reason) }

      context 'when reason does not exist' do
        it 'returns 401' do
          post '/api/v1/user_reports',
               headers: { 'HTTP_AUTHORIZATION' => token },
               params: {
                 reason_id: 'random',
                 comment: '',
                 user_id: for_user
               }

          expect(response.status).to eq 404
        end
      end

      context 'when to user does not exist' do
        it 'returns 401' do
          post '/api/v1/user_reports',
               headers: { 'HTTP_AUTHORIZATION' => token },
               params: {
                 reason_id: reason.id,
                 comment: '',
                 user_id: 'random_id'
               }

          expect(response.status).to eq 404
        end
      end

      context 'when valid params' do
        it 'returns 200' do
          post '/api/v1/user_reports',
               headers: { 'HTTP_AUTHORIZATION' => token },
               params: {
                 reason_id: reason.id,
                 comment: '',
                 user_id: for_user.id
               }

          expect(response.status).to eq 200
        end
      end
    end
  end
end
