# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Authorization', type: :request do
  describe '/api/v1/auth' do
    context 'when token is missing' do
      it 'returns 400' do
        post '/api/v1/auth',
             params: { auth_method: 'facebook', token: '' }

        expect(response.status).to eq 400
      end
    end

    context 'when invalid auth method' do
      it 'returns 400' do
        post '/api/v1/auth',
             params: { auth_method: 'random', token: '' }

        expect(response.status).to eq 400
        expect(JSON.parse(response.body, symbolize_names: true)[:error]).to eq('random is not a valid auth method')
      end
    end

    context 'google sign in' do
      context 'when valid token and user did not exist' do
        let(:token) do
          <<-TEXT.squish
            eyJhbGciOiJSUzI1NiIsImtpZCI6Ijg1ODI4YzU5Mjg0YTY5YjU0YjI3NDgzZTQ4N2MzYmQ0NmNkMmEyYjMiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTg2NzE1OTU3NzMtNmxxNmNnOTA4MDBtMGxkdGM5bGpyb3NsZGIzamlnNGUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTg2NzE1OTU3NzMtNXZoNXViOWZtODY5ZjMzMzdlNmRrMTNobWRyYnI3bjYuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTA3ODExNjgxMzUwOTUxNjYwMjAiLCJoZCI6ImJhZXRvYmUuY29tIiwiZW1haWwiOiJnYXVyYXZAYmFldG9iZS5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6IkdhdXJhdiBSYWtoZWphIiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FBVFhBSndPSENMQThUaVZoVEQ1anlqd1oxU1F3TUExY2xJR1hNQ2w5ZWFKPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkdhdXJhdiIsImZhbWlseV9uYW1lIjoiUmFraGVqYSIsImxvY2FsZSI6ImVuLUdCIiwiaWF0IjoxNjM2MTkyMzk1LCJleHAiOjE2MzYxOTU5OTV9.XkCUgrE-EMufnICnzsjYvrHIJOycJMUeXGeksxhCa_E5AWq2-hgM_LgjLjOI52zWxnOPU_VEPWGl1c0ojU5jgWS4It_48KdZ_Kc_2jATVInmSY7l4Jl_LLRLzkn_n3eq4_yXcT8sIN6rTX-kr6nAmOrnIOIV3wUeAbTxL0ZmxSlkzLjgygM1KZvw6ssgSqL2LT00Xq3HgX4L-x-4tYkUe9g7ldCNIpiRIOdR-901GV5mMRYXHgwk8X4ft_6bz-dzFnmZwRvUb7a9RKMiNzXU-HxRcRUdo7tFMPPXR4w_CkuBXFUoQNHDCTHnjDSX3ldMTl8MCBqz7darIj5We6F9PA
          TEXT
        end

        it 'creates the user and returns 200' do
          Timecop.freeze(2021, 11, 6, 10, 32, 41) do
            VCR.use_cassette('google_certs', match_requests_on: %i[body path method]) do
              post '/api/v1/auth',
                   params: { auth_method: 'google', token: token }
              expect(response.status).to eq 200
              response_user = JSON.parse(response.body, symbolize_names: true)[:data]
              expect(response_user[:access_token]).to_not be nil
              user = User.last
              expect(Auth::Token.parsed_token(response_user[:access_token])['id']).to eq user.id
              expect(RefreshToken.find_by_token(response_user[:refresh_token])).to eq user.refresh_tokens.last
              expect(response_user[:is_new_user]).to eq true
            end
          end
        end
      end

      context 'when valid token and user did not exist on ios' do
        let(:token) do
          <<-TEXT.squish
            eyJhbGciOiJSUzI1NiIsImtpZCI6ImQ5OGY0OWJjNmNhNDU4MWVhZThkZmFkZDQ5NGZjZTEwZWEyM2FhYjAiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTg2NzE1OTU3NzMtZHZ2MzV0amZyaXNuYzFzcTRrZXFiZ2Q1OWpucm1nYmouYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTg2NzE1OTU3NzMtZHZ2MzV0amZyaXNuYzFzcTRrZXFiZ2Q1OWpucm1nYmouYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMTA3ODExNjgxMzUwOTUxNjYwMjAiLCJoZCI6ImJhZXRvYmUuY29tIiwiZW1haWwiOiJnYXVyYXZAYmFldG9iZS5jb20iLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiYXRfaGFzaCI6IjlFR0gtbTR5bS1aUmE0TVZtcXpjWmciLCJub25jZSI6InZVUjhYcm9DT1pjNnhweGE0czFTeEF4VEc4bGRxY0w5OW8tT0JVMkg2XzQiLCJuYW1lIjoiR2F1cmF2IFJha2hlamEiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUFUWEFKd09IQ0xBOFRpVmhURDVqeWp3WjFTUXdNQTFjbElHWE1DbDllYUo9czk2LWMiLCJnaXZlbl9uYW1lIjoiR2F1cmF2IiwiZmFtaWx5X25hbWUiOiJSYWtoZWphIiwibG9jYWxlIjoiZW4tR0IiLCJpYXQiOjE2Mzk4MTI5MzgsImV4cCI6MTYzOTgxNjUzOH0.kGN5-juSHPCwlJzzliwG4jTV2nBVxFztpL3d68uQkS8Ib49IZwN3b8_DJ4eF-iBUMc96FDAxo8zhdQ92N9-_xMQg-JwI15Qxs9Wt3am0tP51YoNCLEb7EpPipnc0r4QOGHtHjw1iWvoka6633yB6SdS2JEzcBmQA8GyfJ-TJeCIrNHU17-eoyHEYiH5_J-1Kg1QSmtDmSQnZ4iwIDa-xdvo-XxKfxaOiTg3JYXaDoQ6s0ZavFBdvob5j9aWp5Ovm_CpxkUPLXNk9h4dcZD6W3U2kDNCz0x-mEeKFH9Ir-wwGE9OrMRBgeBy_UC_aqLsGXUo-bIWWXtPjTYWlYVI2MQ
          TEXT
        end

        it 'creates the user and returns 200' do
          Timecop.freeze(2021, 12, 18, 7, 38, 41) do
            VCR.use_cassette('google_certs_ios', match_requests_on: %i[body path method]) do
              post '/api/v1/auth',
                   params: { auth_method: 'google', token: token, platform: 'ios' }
              expect(response.status).to eq 200
              response_user = JSON.parse(response.body, symbolize_names: true)[:data]
              expect(response_user[:access_token]).to_not be nil
              user = User.last
              expect(Auth::Token.parsed_token(response_user[:access_token])['id']).to eq user.id
              expect(RefreshToken.find_by_token(response_user[:refresh_token])).to eq user.refresh_tokens.last
              expect(response_user[:is_new_user]).to eq true
            end
          end
        end
      end
    end

    context 'facebook sign in' do
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
                 params: { auth_method: 'facebook', token: token }
            expect(response.status).to eq 200
            response_user = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(response_user[:access_token]).to_not be nil
            user = User.last
            expect(Auth::Token.parsed_token(response_user[:access_token])['id']).to eq user.id
            expect(RefreshToken.find_by_token(response_user[:refresh_token])).to eq user.refresh_tokens.last
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
                 params: { auth_method: 'facebook', token: token }
            expect(response.status).to eq 200
            response_user = JSON.parse(response.body, symbolize_names: true)[:data]
            expect(response_user[:access_token]).to_not be nil

            expect(RefreshToken.find_by_token(response_user[:refresh_token])).to eq user.refresh_tokens.last
            expect(response_user[:is_new_user]).to eq false
          end
        end
      end

      context 'when invalid token' do
        let(:token) { 'random_string' }

        it 'creates the user and returns 200' do
          VCR.use_cassette('invalid_facebook_token', match_requests_on: %i[body path method]) do
            post '/api/v1/auth',
                 params: { auth_method: 'facebook', token: token }
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

  describe '/api/v1/logout' do
    context 'when refresh token missing' do
      it 'returns 401' do
        post '/api/v1/logout'
        expect(response.status).to eq 400
      end
    end

    context 'when refresh token present' do
      let!(:user) { create(:user, email: 'gaurav@baetobe.com') }
      let!(:token) { user.refresh_tokens.create! }

      it 'returns 200' do
        post '/api/v1/logout',
             params: { refresh_token: token.token }
        expect(user.refresh_tokens.reload).to be_blank
        expect(response.status).to eq(200)
      end
    end
  end

  describe '/api/v1/refresh_token' do
    context 'when token missing' do
      it 'returns 400' do
        post '/api/v1/refresh_token'
        expect(response.status).to eq 400
        expect(JSON.parse(response.body, symbolize_names: true)[:error])
          .to eq 'Refresh token is a required parameter'
      end
    end

    context 'when token is invalid' do
      it 'returns 401' do
        post '/api/v1/refresh_token',
             params: { refresh_token: 'random_string' }
        expect(response.status).to eq 401
        expect(JSON.parse(response.body, symbolize_names: true)[:error])
          .to eq 'Invalid refresh token passed'
      end
    end

    context 'when token is valid' do
      let!(:user) { create(:user, email: 'gaurav@baetobe.com') }
      let!(:token) { user.refresh_tokens.create! }

      it 'returns 200' do
        post '/api/v1/refresh_token',
             params: { refresh_token: token.token }
        expect(response.status).to eq(200)
        data = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(data[:access_token]).not_to be_nil
      end
    end
  end
end
