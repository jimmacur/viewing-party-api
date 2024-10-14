class ViewingPartyGateway
  attr_reader :errors

  def initialize(current_user, viewing_party_params, invitees = [])
    @current_user = current_user
    @viewing_party_params = viewing_party_params
    @invitees = invitees
    @errors = []
  end

  def create_viewing_party
    viewing_party = ViewingParty.new(@viewing_party_params.except(:api_key))
    viewing_party.host = @current_user

    if viewing_party.save
      add_invitees(viewing_party)
      viewing_party
    else
      @errors = viewing_party.errors.full_messages
      nil
    end
  end

  def add_invitees(viewing_party, invitee_user_id)
    invitee_user = User.find_by(id: invitee_user_id)
    return nil unless invitee_user

    Invitation.create(viewing_party: viewing_party, user: invitee_user)
    viewing_party
  end

  private

  def add_invitees(viewing_party)
    @invitees.each do |invitee_id|
      user = User.find_by(id: invitee_id)
      Invitation.create(viewing_party: viewing_party, user: user) if user
    end
  end
end