# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Authorization', type: :request do
  describe '/api/v1/auth' do
    context 'when token is missing' do
      it 'returns 400' do
        post '/api/v1/auth',
             params: { token: '' }

        expect(response.status).to eq 400
      end
    end

    context 'when valid token and user did not exist' do
      let(:token) do
        <<-TEXT.squish
          EAAEXaAklTiMBAALXawA4bd6gWJT9NA39nZC
          Tp80aC1XX7YECPwWKAmbZBJbKoZANZBAaEg3
          SIbIzuULmbtvyZCaKUZBjN21uxRq0SJKdH6L
          TJ9BT3zSRh8WzeVbK4ZBlxAuZCILkGI638EL
          7agUdnJYjI81z9HYwiBR8VF2USrjqG6gZBgo
          uOAasBsCBaCdBuLuQFfyxHgs9kLPB1yGJBZA
          knBKtQbOecROXQZD
        TEXT
      end

      it 'creates the user and returns 200' do
        VCR.use_cassette('valid_facebook_token', match_requests_on: %i[body path method]) do
          post '/api/v1/auth',
               params: { token: token }
          expect(response.status).to eq 200
          response_user = JSON.parse(response.body, symbolize_names: true)[:data]
          expect(response_user[:token]).to_not be nil
          expect(response_user[:is_new_user]).to eq true
        end
      end
    end

    context 'when valid token and user already existed' do
      let(:token) do
        <<-TEXT.squish
          EAAEXaAklTiMBAALXawA4bd6gWJT9NA39nZC
          Tp80aC1XX7YECPwWKAmbZBJbKoZANZBAaEg3
          SIbIzuULmbtvyZCaKUZBjN21uxRq0SJKdH6L
          TJ9BT3zSRh8WzeVbK4ZBlxAuZCILkGI638EL
          7agUdnJYjI81z9HYwiBR8VF2USrjqG6gZBgo
          uOAasBsCBaCdBuLuQFfyxHgs9kLPB1yGJBZA
          knBKtQbOecROXQZD
        TEXT
      end
      let!(:user) { create(:user, email: 'gaurav@baetobe.com') }

      it 'creates the user and returns 200' do
        VCR.use_cassette('valid_facebook_token_existing_user', match_requests_on: %i[body path method]) do
          post '/api/v1/auth',
               params: { token: token }
          expect(response.status).to eq 200
          response_user = JSON.parse(response.body, symbolize_names: true)[:data]
          expect(response_user[:token]).to_not be nil
          expect(response_user[:is_new_user]).to eq false
        end
      end
    end

    context 'when invalid token' do
      let(:token) { 'random_string' }

      it 'creates the user and returns 200' do
        VCR.use_cassette('invalid_facebook_token', match_requests_on: %i[body path method]) do
          post '/api/v1/auth',
               params: { token: token }
          expect(response.status).to eq(401)
          response_body = JSON.parse(response.body, symbolize_names: true)
          expect(response_body).to eq({
            data: nil,
            error: 'invalid token',
            success: false
          })
        end
      end
    end
  end
end
