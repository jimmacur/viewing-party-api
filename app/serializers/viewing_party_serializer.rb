class ViewingPartySerializer
  include JSONAPI::Serializer

  attributes :name, :start_time, :end_time, :movie_id, :movie_title

  attribute :host do |party|
    {
      id: party.host.id,
      name: party.host.name,
      username: party.host.username
    }
  end

  attribute :invitees do |party|
    party.invitees.map do |invitee|
      {
        id: invitee.id,
        name: invitee.name,
        username: invitee.username
      }
    end
  end
end