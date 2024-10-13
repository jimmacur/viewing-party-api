class ViewingPartyGateway
  def initialize(current_user, viewing_party_params, invitees = [])
    @current_user = current_user
    @viewing_party_params = viewing_party_params
    @invitees = invitees
  end

  def create_viewing_party
    viewing_party = ViewingParty.new(@viewing_party_params.except(:api_key))
    viewing_party.host = @current_user

    if viewing_party.save
      add_invitees(viewing_party, @invitees)
      viewing_party
    else
      nil
    end
  end

  def add_invitees(viewing_party, invitee_user_ids)
    Array(invitee_user_ids).each do |invitee_id|
      user = User.find_by(id: invitee_id)
      Invitation.create(viewing_party: viewing_party, user: user) if user
    end
    viewing_party
  end
end