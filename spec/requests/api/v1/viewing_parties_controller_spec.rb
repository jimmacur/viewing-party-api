require 'rails_helper'

RSpec.describe "Viewing Parties Controller" do
  before do
    @host = User.create!(name: 'Juliet', username: 'juliet_bash', password: 'SecurePass123!', api_key: 'e1An')
    @invitee1 = User.create!(name: 'Barbara', username: 'leo_fan', password: 'LeoIsBest456!')
    @invitee2 = User.create!(name: 'Ceci', username: 'titanic_forever', password: 'IceBerg789!')
  end

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
end