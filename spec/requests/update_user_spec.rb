# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Update user fields', type: :request do
  describe '/api/v1/user' do
    context 'when unauthorized' do
      it 'returns 401' do
        patch '/api/v1/user',
              params: {},
              headers: { 'HTTP_AUTHORIZATION' => 'random_string' }

        expect(response.status).to eq 401
      end
    end

    context 'when valid user' do
      let!(:user) { create(:user) }
      let!(:gender) { create(:gender) }
      let!(:industry) { create(:industry) }
      let!(:interested_gender) { create(:gender) }
      let!(:token) { Auth::Token.jwt_token(user) }
      let(:birthday) { '02-01-1997' }
      let(:linkedin_url) { 'https://www.linkedin.com/in/test-user' }
      let(:company_name) { 'test company' }
      let(:work_title_name) { 'engineer' }
      let(:location) { { lat: 72.877426, lng: 19.07609 } }

      it 'successfully updates every attribute' do
        expect(user.gender_id).to be_nil
        expect(user.birthday).to_not eq(birthday)
        expect(user.linkedin_url).to be_nil
        expect(user.company_id).to be_nil
        expect(user.company_id).to be_nil

        patch '/api/v1/user',
              params: {
                gender_id: gender.id,
                interested_gender_ids: [interested_gender.id],
                birthday: birthday,
                industry_id: industry.id,
                linkedin_url: linkedin_url,
                company_name: company_name,
                work_title_name: work_title_name,
                location: location,
                student: true
              },
              headers: { 'HTTP_AUTHORIZATION' => token }
        expect(response.status).to eq 200
        user.reload
        expect(user.gender_id).to eq(gender.id)
        expect(user.birthday).to_not eq(birthday)
        expect(user.linkedin_url).to eq(linkedin_url)
        expect(user.company.name).to eq(company_name.titleize)
        expect(user.lat).to eq(location[:lat])
        expect(user.lng).to eq(location[:lng])
        expect(user.student?).to eq true
      end
    end
  end
end