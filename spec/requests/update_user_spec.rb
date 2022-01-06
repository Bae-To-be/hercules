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
      let!(:course) { create(:course) }
      let!(:university) { create(:university) }
      let!(:token) { Auth::Token.jwt_token(user) }
      let(:birthday) { '02-01-1997' }
      let(:linkedin_url) { 'https://www.linkedin.com/in/test-user' }
      let(:company_name) { 'test company' }
      let(:work_title_name) { 'engineer' }
      let(:location) { { lat: 72.877426, lng: 19.07609 } }
      let(:bio) { 'some random bio' }
      let(:country) { 'United States' }
      let(:city) { create(:city) }
      let(:religion) { create(:religion) }
      let(:height) { 171 }
      let(:language) { create(:language) }

      before do
        create(:verification_file, user: user, file_type: :selfie)
        create(:verification_file, user: user, file_type: :identity)
        create(:image, user: user)
        create(:image, user: user)
      end

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
                education: [
                  course_name: course.name,
                  university_name: university.name,
                  year: 2019
                ],
                language_ids: [language.id],
                height_in_cms: height,
                hometown: {
                  city_name: city.name,
                  country_name: country
                },
                fcm_token: 'some_token',
                bio: bio,
                religion_id: religion.id
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
        expect(user.interested_age_lower).to eq [(user.current_age - ENV.fetch('LOWER_AGE_BUFFER').to_i), 18].max
        expect(user.interested_age_upper).to eq user.current_age + ENV.fetch('UPPER_AGE_BUFFER').to_i
        expect(user.verification_requests.last).to be_in_review
        expect(user.bio).to eq bio
        expect(user.hometown_city_id).to eq city.id
        expect(user.hometown_country).to eq country
        expect(user.fcm['token']).to eq 'some_token'
        expect(user.religion).to eq religion
        expect(user.height_in_cms).to eq height
        expect(user.languages[0]).to eq language

        user.verification_requests.last.update(
          status: :rejected,
          dob_approved: false,
          education_approved: true,
          work_details_approved: true,
          selfie_approved: true,
          identity_approved: true,
          linkedin_approved: true
        )
      end
    end
  end
end
