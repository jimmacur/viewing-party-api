require 'rails_helper'

RSpec.describe ViewingPartyGateway do
  before do  
    @host = User.create!(name: 'Host User', username: 'host_user', api_key: 'valid_api_key', password: 'password123')
    @invitee1 = User.create!(name: 'Invitee One', username: 'invitee_one', password: 'password123')
    @invitee2 = User.create!(name: 'Invitee Two', username: 'invitee_two', password: 'password123')
    
    @viewing_party_params = {
      name: "Juliet's Bday Movie Bash!",
      start_time: "2025-02-01 10:00:00",
      end_time: "2025-02-01 14:30:00",
      movie_id: 278,
      movie_title: "The Shawshank Redemption"
    }
    @invitees = [@invitee1.id, @invitee2.id]
    @gateway = ViewingPartyGateway.new(@host, @viewing_party_params, @invitees)
  end

  describe '#create_viewing_party' do
    it 'creates a viewing party' do
      expect { @gateway.create_viewing_party }.to change { ViewingParty.count }.by(1)
    end

    it 'associates the viewing party with the host' do
      viewing_party = @gateway.create_viewing_party
      expect(viewing_party.host).to eq(@host)
    end

    it 'adds invitees to the viewing party' do
      viewing_party = @gateway.create_viewing_party
      expect(viewing_party.invitees).to include(@invitee1, @invitee2)
      expect(viewing_party.invitees.count).to eq(2)
    end

    context "when the viewing party is invalid" do
      before do
        @invalid_params = @viewing_party_params.merge(name: nil)
        @gateway = ViewingPartyGateway.new(@host, @invalid_params, @invitees) 
      end

      it 'does not create a viewing party' do
        expect(@gateway.create_viewing_party).to be_nil
        expect(ViewingParty.count).to eq(0)
      end
    end
  end

  describe '#add_invitees' do
    before do  
      @viewing_party = ViewingParty.create!(
        name: @viewing_party_params[:name],
        start_time: @viewing_party_params[:start_time],
        end_time: @viewing_party_params[:end_time],
        movie_id: @viewing_party_params[:movie_id],
        movie_title: @viewing_party_params[:movie_title],
        host: @host
      )
    end

    it 'adds an invitee to the viewing party when the invitee exists' do
      expect { @gateway.add_invitees(@viewing_party, @invitee1.id) }.to change { @viewing_party.invitees.count }.by(1)
      expect(@viewing_party.invitees).to include(@invitee1)
    end

    it 'does not add an invitee to the viewing party when the invitee does not exist' do
      expect { @gateway.add_invitees(@viewing_party, 999) }.not_to change { @viewing_party.invitees.count }
    end
  end
end