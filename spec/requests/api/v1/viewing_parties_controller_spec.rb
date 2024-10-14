require 'rails_helper'

RSpec.describe "Viewing Parties Controller" do
  before do
    @host = User.create!(name: 'Juliet', username: 'juliet_bash', password: 'SecurePass123!', api_key: 'e1An')
    @invitee1 = User.create!(name: 'Barbara', username: 'leo_fan', password: 'LeoIsBest456!')
    @invitee2 = User.create!(name: 'Ceci', username: 'titanic_forever', password: 'IceBerg789!')

  end

  describe 'POST /api/v1/viewing_parties' do
    it 'creates a viewing party with a valid API key' do
      party_params = {
        viewing_party: {
          name: "Juliet's Bday Movie Bash!",
          start_time: "2025-02-01 10:00:00",
          end_time: "2025-02-01 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption"
        },
        api_key: @host.api_key,
        invitees: [@invitee1.id, @invitee2.id]
      }

      post '/api/v1/viewing_parties', params: party_params

      expect(response).to have_http_status(:created)
      expect(ViewingParty.count).to eq(1)
      expect(Invitation.count).to eq(2)
    end

    it 'returns an error with an invalid API key' do
      party_params = {
          viewing_party: {
            name: "Juliet's Bday Movie Bash!",
            start_time: "2025-02-01 10:00:00",
            end_time: "2025-02-01 14:30:00",
            movie_id: 278,
            movie_title: "The Shawshank Redemption"
          },
          api_key: 'invalid_key',
          invitees: [@invitee1.id, @invitee2.id]
        }

      post '/api/v1/viewing_parties', params: party_params

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid API key' })
      expect(ViewingParty.count).to eq(0)
      expect(Invitation.count).to eq(0)
    end

    it 'returns an error with missing required params' do
      party_params = {
        viewing_party: {
          name: nil,
          start_time: "2025-02-01 10:00:00",
          end_time: "2025-02-01 14:30:00",
          movie_id: 278,
          movie_title: "The Shawshank Redemption"
        },
        api_key: @host.api_key,
        invitees: []
      }

      post '/api/v1/viewing_parties', params: party_params

      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({ 'error' => "Name can't be blank" })
      expect(ViewingParty.count).to eq(0)
      expect(Invitation.count).to eq(0)
    end
  end

  describe 'PATCH /api/v1/viewing_parties/:id' do  
    before do
      @viewing_party = ViewingParty.create!(
        host: @host,
        name: "Juliet's Bday Movie Bash!",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 14:30:00",
        movie_id: 278,
        movie_title: "The Shawshank Redemption"
      )
    end

    it 'successfully invites a user if the current user is the host' do
      new_invitee = User.create!(name: 'Alex', username: 'alex_123', password: 'Pass123!')

      patch "/api/v1/viewing_parties/#{@viewing_party.id}", params: {
        api_key: @host.api_key,
        invitees: [new_invitee.id]
      }

      expect(response).to be_successful
      expect(@viewing_party.invitations.count).to eq(1)
      expect(@viewing_party.invitations.first.user).to eq(new_invitee)
    end

    it 'returns an error if the current user is not the host' do
      non_host = User.create!(name: 'Nothost', username: 'not_host_123', password: 'Pass123!')

      patch "/api/v1/viewing_parties/#{@viewing_party.id}", params: {
        api_key: non_host.api_key,
        invitees: [@invitee1.id]
      }

      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'You are not the host of this viewing party' })
    end

    it 'returns an error if the invitee does not exist' do
      patch "/api/v1/viewing_parties/#{@viewing_party.id}", params: {
        api_key: @host.api_key,
        invitees: [999999]
      }

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)).to eq({ 'error' => 'User with id 999999 not found' })
    end
  end
end