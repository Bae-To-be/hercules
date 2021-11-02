# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Find potential Matches', type: :request do
  describe '/api/v1/potential_matches' do
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
        let(:another_university) { create(:university) }
        let(:course) { create(:course) }
        let(:another_course) { create(:course) }
        let(:related_course) { create(:course) }
        let!(:gender) { create(:gender) }
        let!(:interested_gender) { create(:gender) }
        let!(:another_gender) { create(:gender) }
        let!(:user) do
          create(:user,
                 course: course,
                 gender: gender,
                 birthday: Time.zone.today - 18.years,
                 interested_age_lower: 18,
                 interested_age_upper: 23,
                 search_radius: 90_000,
                 university: university)
        end
        let!(:token) { Auth::Token.jwt_token(user) }

        before do
          create(:course_relationship, source: course, target: related_course)
          create(:user_gender_interest, user: user, gender: interested_gender)
        end

        context 'when there are enough profiles in the same course' do
          let!(:candidate_1) do
            create(:user,
                   birthday: Time.zone.today - 21.years,
                   gender: interested_gender,
                   university: another_university,
                   course: course)
          end

          let!(:candidate_2) do
            create(:user,
                   gender: interested_gender,
                   university: another_university,
                   birthday: Time.zone.today - 20.years,
                   course: course)
          end

          let!(:candidate_3) do
            create(:user,
                   gender: interested_gender,
                   university: another_university,
                   birthday: Time.zone.today - 18.years,
                   course: another_course)
          end

          let!(:candidate_4) do
            create(:user,
                   gender: interested_gender,
                   university: another_university,
                   birthday: Time.zone.today - 22.years,
                   course: related_course)
          end

          let!(:candidate_5) do
            create(:user,
                   gender: another_gender,
                   university: university,
                   birthday: Time.zone.today - 19.years,
                   course: related_course)
          end

          let!(:candidate_6) do
            create(:user,
                   gender: interested_gender,
                   university: another_university,
                   birthday: Time.zone.today - 24.years,
                   course: course)
          end

          before do
            create(:user_gender_interest, user: candidate_1, gender: gender)
            create(:user_gender_interest, user: candidate_2, gender: gender)
            create(:user_gender_interest, user: candidate_3, gender: gender)
            create(:user_gender_interest, user: candidate_4, gender: gender)
            create(:user_gender_interest, user: candidate_5, gender: gender)
            create(:user_gender_interest, user: candidate_6, gender: gender)
          end

          context 'when 2 results requested' do
            it 'contains only members from same course' do
              get '/api/v1/potential_matches',
                  headers: { 'HTTP_AUTHORIZATION' => token },
                  params: { limit: 2 }

              users = JSON.parse(response.body, symbolize_names: true)[:data]
              expect(users.size).to eq 2
              expect(users).to include candidate_1.to_h
              expect(users).to include candidate_2.to_h
            end
          end

          context 'when 3 results requested' do
            it 'contains members from same course and related course' do
              get '/api/v1/potential_matches',
                  headers: { 'HTTP_AUTHORIZATION' => token },
                  params: { limit: 3 }

              users = JSON.parse(response.body, symbolize_names: true)[:data]
              expect(users.size).to eq 3
              expect(users).to include candidate_1.to_h
              expect(users).to include candidate_2.to_h
              expect(users).to include candidate_4.to_h
            end
          end

          context 'when 5 results requested' do
            before do
              create(:swipe, from: user, to: candidate_1)
            end

            it 'contains all the members in the age range and returns with lesser rows if it has to' do
              get '/api/v1/potential_matches',
                  headers: { 'HTTP_AUTHORIZATION' => token },
                  params: { limit: 5 }

              users = JSON.parse(response.body, symbolize_names: true)[:data]
              expect(users.size).to eq 3
              expect(users).to_not include candidate_1.to_h
              expect(users).to include candidate_2.to_h
              expect(users).to include candidate_3.to_h
              expect(users).to include candidate_4.to_h
            end
          end
        end

        context 'when there are no people in the age range preference' do
          let!(:candidate_6) do
            create(:user,
                   gender: interested_gender,
                   university: another_university,
                   birthday: Time.zone.today - 24.years,
                   course: course)
          end

          before do
            create(:user_gender_interest, user: candidate_6, gender: gender)
          end

          it 'returns empty results' do
            get '/api/v1/potential_matches',
                headers: { 'HTTP_AUTHORIZATION' => token },
                params: { limit: 5 }

            users = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(users).to be_empty
          end
        end
      end

      context 'when user is a professional' do
      end
    end
  end
end
