require 'rails_helper'

RSpec.describe MovieSearchGateway, type: :service do
  let(:movie_id) { '122' }
  let(:gateway) { MovieSearchGateway.new(movie_id) }
  let(:api_key) { Rails.application.credentials.movie_db[:api_key] } 
  let(:json_response) { File.read('spec/fixtures/lotr_full_response.json') }

  describe '#call' do
    it 'returns movie details' do
      stub_request(:get, "https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{api_key}&append_to_response=credits,reviews")
        .to_return(status: 200, body: json_response)

      movie_data = gateway.call

      expect(movie_data[:id]).to eq(122)
      expect(movie_data[:title]).to eq("The Lord of the Rings: The Return of the King")
      expect(movie_data[:release_date]).to eq("2003-12-17")
      expect(movie_data[:vote_average]).to eq(8.482)
      expect(movie_data[:runtime]).to eq(201)
      expect(movie_data[:genres]).to eq(["Adventure", "Fantasy", "Action"])
      expect(movie_data[:overview]).to eq("As armies mass for a final battle that will decide the fate of the world--and powerful, ancient forces of Light and Dark compete to determine the outcome--one member of the Fellowship of the Ring is revealed as the noble heir to the throne of the Kings of Men. Yet, the sole hope for triumph over evil lies with a brave hobbit, Frodo, who, accompanied by his loyal friend Sam and the hideous, wretched Gollum, ventures deep into the very dark heart of Mordor on his seemingly impossible quest to destroy the Ring of Power.​")
      expect(movie_data[:credits]).to be_a(Hash)
      expect(movie_data[:reviews]).to be_a(Hash)
    end

    it 'returns nil when movie is not found' do
      stub_request(:get, "https://api.themoviedb.org/3/movie/#{movie_id}?api_key=#{api_key}&append_to_response=credits,reviews")
        .to_return(status: 404)

      movie_data = gateway.call

      expect(movie_data).to be_nil
    end
  end
end