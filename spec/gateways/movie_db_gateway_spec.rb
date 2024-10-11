require 'rails_helper'

RSpec.describe MovieDbGateway, type: :service do
  let(:gateway) { MovieDbGateway.new }
  let(:api_key) { Rails.application.credentials.movie_db[:api_key] }

  describe '#top_rated_movies' do
    it 'returns a list of top rated movies' do
      json_response = File.read('spec/fixtures/top_rated_movies.json')

      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated")
        .with(query: { api_key: api_key })
        .to_return(status: 200, body: json_response)

      movies = gateway.top_rated_movies

      expect(movies.count).to eq(20)
      expect(movies.first).to be_a(Movie)
      expect(movies.first.id).to eq('278')
      expect(movies.first.title).to eq("The Shawshank Redemption")
      expect(movies.first.vote_average).to eq(8.707)
    end
  end

  describe '#movie_search' do
    it 'returns serach results when a valid query is provided' do
      json_response = File.read('spec/fixtures/movie_search_results.json')

      stub_request(:get, "https://api.themoviedb.org/3/search/movie")
        .with(query: { api_key: api_key, query: 'Lord of the Rings' })
        .to_return(status: 200, body: json_response)

      movies = gateway.movie_search('Lord of the Rings')

      expect(movies.count).to eq(20)
      expect(movies.first).to be_a(Movie)
      expect(movies.first.id).to eq('122')
      expect(movies.first.title).to eq("The Lord of the Rings: The Return of the King")
      expect(movies.first.vote_average).to eq(8.5)
    end

    it 'returns an empty array when no results are found' do
      empty_response = { results: [] }.to_json

      stub_request(:get, "https://api.themoviedb.org/3/search/movie")
        .with(query: { api_key: api_key, query: 'It Doesnt Exist Movie' })
        .to_return(status: 200, body: empty_response)

      movies = gateway.movie_search('It Doesnt Exist Movie')

      expect(movies).to be_empty
    end
  end
end