# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Create Swipe', type: :request do
  xdescribe '/api/v1/potential_matches' do
    context 'when token is missing' do
      it 'returns 401' do
        get '/api/v1/potential_matches',
            headers: { 'HTTP_AUTHORIZATION' => '' }

        expect(response.status).to eq 401
      end
    end

    context 'when token is valid' do
      context 'when user is a student' do
        let(:university) { create(:university) }
        let(:course) { create(:course) }
        let(:another_course) { create(:another_course) }
        let(:related_course) { create(:course) }
        let(:gender) { create(:gender) }
        let(:interested_gender) { create(:gender) }
        let(:another_gender) { create(:another_gender) }
        let!(:user) do
          create(:user,
                 course: course,
                 gender: gender,
                 birthday: Time.zone.today - 18.years,
                 interested_age_lower: 18,
                 interested_age_upper: 23,
                 university: university)
        end
        let!(:token) { Auth::Token.jwt_token(user) }

        before do
          create(:course_relationship, source: course, target: related_course)
          create(:user_gender_interests, user: user, gender: interested_gender)
        end

        context 'when there are enough profiles in the same course' do
          let!(:candidate_1) do
            create(:user,
                   gender: interested_gender,
                   course: course)
          end

          let!(:candidate_2) do
            create(:user,
                   gender: interested_gender,
                   course: course)
          end

          let!(:candidate_3) do
            create(:user,
                   gender: interested_gender,
                   course: another_course)
          end

          let!(:candidate_4) do
            create(:user,
                   gender: interested_gender,
                   course: related_course)
          end

          let!(:candidate_5) do
            create(:user,
                   gender: another_gender,
                   course: related_course)
          end

          let!(:candidate_6) do
            create(:user,
                   gender: another_gender,
                   course: related_course)
          end

          before do
            create(:user_gender_interests, user: candidate_1, gender: gender)
          end

          context 'when 2 results requested' do
            it 'contains only members from same course' do
            end
          end

          context 'when 3 results requested' do
            it 'contains members from same course and related course' do
            end
          end

          context 'when 5 results requested' do
            it 'contains all the members in the age range and returns with lesser rows if it has to' do
            end
          end
        end

        context 'when there are not enough profiles in the same course' do
        end

        context 'when there are no people in the age range preference' do
        end
      end

      context 'when user is a professional' do
      end
    end
  end
end
