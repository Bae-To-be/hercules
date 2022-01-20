# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Likes Sent/Received', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { Auth::Token.jwt_token(user) }

  describe '/api/v1/swipes' do
    context 'when token is missing' do
      it 'received endpoint returns 401' do
        get '/api/v1/likes/sent',
            headers: { 'HTTP_AUTHORIZATION' => '' }

        expect(response.status).to eq 401
      end

      it 'received endpoint returns 401' do
        get '/api/v1/likes/received',
            headers: { 'HTTP_AUTHORIZATION' => '' }

        expect(response.status).to eq 401
      end
    end

    context 'when token is present' do
      let(:user_1) { create(:user) }
      let(:user_2) { create(:user) }
      let(:user_3) { create(:user) }
      let(:user_4) { create(:user) }
      let!(:swipe_from) { create(:swipe, from: user, to: user_1, direction: 'right') }
      let!(:left_from) { create(:swipe, from: user, to: user_2, direction: 'left') }
      let!(:swipe_to) { create(:swipe, to: user, from: user_3, direction: 'right') }
      let!(:left_to) { create(:swipe, to: user, from: user_4, direction: 'left') }

      it 'sent endpoint returns the likes sent' do
        get '/api/v1/likes/sent',
            headers: { 'HTTP_AUTHORIZATION' => token }

        data = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(data).to eq([swipe_from.from_hash])
      end

      it 'received endpoint returns the likes received' do
        get '/api/v1/likes/received',
            headers: { 'HTTP_AUTHORIZATION' => token }

        data = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(data).to eq([swipe_to.to_hash])
      end
    end
  end
end
