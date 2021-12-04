# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'delete image', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { Auth::Token.jwt_token(user) }

  describe '/api/v1/images' do
    context 'when unauthorized' do
      it 'returns 401' do
        delete '/api/v1/images/some_id',
               headers: { 'HTTP_AUTHORIZATION' => 'random_string' }

        expect(response.status).to eq 401
      end
    end

    context 'when valid token' do
      context 'when invalid position' do
        it 'returns 404' do
          delete '/api/v1/images/some_position',
                 headers: { 'HTTP_AUTHORIZATION' => token }
          expect(response.status).to eq 404
        end
      end

      context 'when valid position' do
        let(:owner) { create(:user) }
        let(:image) { create(:image, user: owner) }

        it 'returns 404' do
          delete "/api/v1/images/#{image.position}",
                 headers: { 'HTTP_AUTHORIZATION' => token }
          expect(response.status).to eq 404
        end
      end

      context 'when valid position and user is the owner' do
        let(:image) { create(:image, user: user) }
        it 'returns 200' do
          delete "/api/v1/images/#{image.position}",
                 headers: { 'HTTP_AUTHORIZATION' => token }
          expect(response.status).to eq 200
        end
      end
    end
  end
end
