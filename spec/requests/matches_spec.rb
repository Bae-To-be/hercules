# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Matches ', type: :request do
  include ActionView::Helpers::DateHelper

  let!(:user) { create(:user) }
  let!(:token) { Auth::Token.jwt_token(user) }

  describe 'matches listing' do
    context 'when token is missing' do
      it 'received endpoint returns 401' do
        get '/api/v1/matches',
            headers: { 'HTTP_AUTHORIZATION' => '' }

        expect(response.status).to eq 401
      end
    end

    context 'when token is present' do
      let(:user_1) { create(:user) }
      let(:user_2) { create(:user) }
      let!(:valid_match) { create(:match_store, source: user, target: user_1) }

      before do
        create(:match_store, source: user_2, target: user_1)
      end

      it 'returns all the matches of the current user' do
        get '/api/v1/matches',
            headers: { 'HTTP_AUTHORIZATION' => token },
            params: { limit: 10, page: 1 }
        expect(response.status).to eq 200
        expect(JSON.parse(response.body, symbolize_names: true)[:data])
          .to eq([{
            id: valid_match.id,
            time_since_update: "#{time_ago_in_words(valid_match.updated_at)} ago",
            matched_user: user_1.basic_hash
          }])
      end
    end
  end
end
