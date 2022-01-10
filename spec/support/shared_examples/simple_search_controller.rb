# frozen_string_literal: true

require_relative '../../rails_helper'

RSpec.shared_examples 'simple_search_controller' do |model|
  describe 'index' do
    context 'unauthorized' do
      it 'returns 401' do
        get "/api/v1/#{model.underscore.pluralize}",
            headers: { 'HTTP_AUTHORIZATION' => 'random_string' }

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:instance1) { create(model.underscore) }
      let!(:instance2) { create(model.underscore) }

      let!(:user) { create(:user) }
      let!(:token) { Auth::Token.jwt_token(user) }

      it 'returns all instances' do
        get "/api/v1/#{model.underscore.pluralize}",
            headers: { 'HTTP_AUTHORIZATION' => token },
            params: { query: instance1.name }

        data = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(data).to include(instance1.to_h)
        expect(data).not_to include(instance2.to_h)
      end
    end
  end
end
