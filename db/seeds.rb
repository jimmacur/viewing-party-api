# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

danny = User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7")
dolly = User.create!(name: "Dolly Parton", username: "dollyP", password: "Jolene123")
lionel = User.create!(name: "Lionel Messi", username: "futbol_geek", password: "test123")
barbara = User.create!(name: 'Barbara', username: 'leo_fan', password: 'LeoIsBest456!')
ceci = User.create!(name: 'Ceci', username: 'titanic_forever', password: 'IceBerg789!')
peyton = User.create!(name: 'Peyton', username: 'star_wars_geek_8', password: 'UseTheForce321!')

juliet = User.create!(name: 'Juliet', username: 'juliet_bash', api_key: 'e1An2gAidDbWtJuhbHFKryjU', password: 'SecurePass123!')

party = ViewingParty.create!(
  name: "Juliet's Bday Movie Bash!",
  start_time: '2025-02-01 10:00:00',
  end_time: '2025-02-01 14:30:00',
  movie_id: 278,
  movie_title: 'The Shawshank Redemption',
  host: juliet
)

Invitation.create!(viewing_party: party, user: barbara)
Invitation.create!(viewing_party: party, user: ceci)
Invitation.create!(viewing_party: party, user: peyton)