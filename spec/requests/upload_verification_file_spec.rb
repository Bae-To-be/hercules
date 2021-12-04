# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Upload Verification Files', type: :request do
  let!(:user) { create(:user) }
  let!(:token) { Auth::Token.jwt_token(user) }

  describe '/api/v1/verification_files' do
    context 'when unauthorized' do
      it 'returns 401' do
        post '/api/v1/verification_files',
             params: { image: nil },
             headers: { 'HTTP_AUTHORIZATION' => 'random_string' }

        expect(response.status).to eq 401
      end
    end

    describe 'when invalid image' do
      let(:test_file) { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/sample.txt'))) }

      it 'returns 400 response' do
        post '/api/v1/verification_files',
             params: { file: test_file, file_type: 'selfie' },
             headers: { 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
        expect(response.status).to eq 400
      end
    end

    describe 'when invalid file type' do
      let(:test_file) { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/sample.jpeg'))) }

      it 'returns 400 response' do
        post '/api/v1/verification_files',
             params: { file: test_file, file_type: 'random' },
             headers: { 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
        expect(response.status).to eq 400
      end
    end

    describe 'when valid image for selfie' do
      let(:test_file) {  Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/sample.jpeg'))) }

      it 'returns 200 response' do
        post '/api/v1/verification_files',
             params: { file: test_file, file_type: 'selfie' },
             headers: { 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
        expect(response.status).to eq 200
        response_image = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(response_image[:url]).to end_with('sample.jpeg')
      end
    end

    describe 'pdf not allowed in selfie' do
      let(:test_file) { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/sample.pdf'))) }

      it 'returns 400 response' do
        post '/api/v1/verification_files',
             params: { file: test_file, file_type: 'selfie' },
             headers: { 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
        expect(response.status).to eq 400
      end
    end

    describe 'pdf allowed in identity' do
      let(:test_file) { Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec/fixtures/sample.pdf'))) }

      it 'returns 200 response' do
        post '/api/v1/verification_files',
             params: { file: test_file, file_type: 'identity' },
             headers: { 'HTTP_AUTHORIZATION' => "Bearer #{token}" }
        expect(response.status).to eq 200
      end
    end
  end
end
