require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe '.top_rated_movies' do
    it 'retrieves and parses the top-rated movies' do
      
      json_response = File.read('spec/fixtures/top_rated_movies.json')

      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated")
        .with(query: { api_key: ENV['MOVIE_DB_API_KEY'] })
        .to_return(status: 200, body: json_response)

      movies = Movie.top_rated_movies

      expect(movies.count).to eq(20)
      
      expect(movies.first.id).to eq("278")
      expect(movies.first.title).to eq("The Shawshank Redemption")
      expect(movies.first.vote_average).to eq(8.707)

      expect(movies.last.id).to eq("637")
      expect(movies.last.title).to eq("Life Is Beautiful")
      expect(movies.last.vote_average).to eq(8.448)
    end
  end
end