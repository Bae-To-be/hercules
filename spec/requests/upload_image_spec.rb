# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Upload Image', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { Auth::Token.jwt_token(user) }

  context 'when unauthorized' do
    it 'returns 401' do
      post '/api/v1/images',
           params: { image: nil },
           headers: { 'HTTP_AUTHORIZATION' => 'random_string' }

      expect(response.status).to eq 401
    end
  end

  describe 'when invalid image' do
    let(:test_file) { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/sample.txt'))) }

    it 'returns 400 response' do
      post '/api/v1/images',
           params: { image: test_file },
           headers: { 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
      expect(response.status).to eq 400
    end
  end

  describe 'when valid image' do
    let(:test_file) {  Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/sample.jpeg'))) }

    it 'returns 200 response' do
      post '/api/v1/images',
           params: { image: test_file },
           headers: { 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
      expect(response.status).to eq 200
      response_image = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(response_image[:profile_picture]).to eq(false)
      expect(response_image[:url]).to end_with('sample.jpeg')
    end
  end
end
