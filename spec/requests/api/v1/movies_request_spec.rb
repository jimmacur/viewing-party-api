require 'rails_helper'

RSpec.describe "Movies API", type: :request do
  describe "GET /api/v1/movies" do
    it 'returns top rated movies' do

      json_response = File.read('spec/fixtures/top_rated_movies.json')
      
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated")
        .with(query: { api_key: Rails.application.credentials.movie_db[:api_key] })
        .to_return(status: 200, body: json_response)

      get '/api/v1/movies'

      expect(response).to be_successful

      movies = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(movies.count).to eq(20)
      expect(movies.first[:id]).to eq("278")
      expect(movies.first[:attributes][:title]).to eq("The Shawshank Redemption")
      expect(movies.first[:attributes][:vote_average]).to eq(8.707)
    end

    it 'returns search results when a query is provided' do
      json_response = File.read('spec/fixtures/movie_search_results.json')

      stub_request(:get, "https://api.themoviedb.org/3/search/movie")
        .with(query: { api_key: Rails.application.credentials.movie_db[:api_key], query: 'Lord of the Rings' })
        .to_return(status: 200, body: json_response)

      get '/api/v1/movies', params: { query: 'Lord of the Rings' }

      movies = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(movies.count).to eq(20)
      expect(movies.first[:id]).to eq("122")
      expect(movies.first[:attributes][:title]).to eq("The Lord of the Rings: The Return of the King")
      expect(movies.first[:attributes][:vote_average]).to eq(8.5)
    end
  end

  describe "GET /api/v1/vovies/:id" do
    it 'returns desired movie details when movie exists' do
      movie_id = 122
      json_response = File.read("spec/fixtures/lotr_full_response.json")

      stub_request(:get, "https://api.themoviedb.org/3/movie/#{movie_id}")
          .with(query: { api_key: Rails.application.credentials.movie_db[:api_key], append_to_response: 'credits,reviews' })
          .to_return(status: 200, body: json_response)

      get "/api/v1/movies/#{movie_id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      parsed_response = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_response).to have_key(:data)
      expect(parsed_response[:data]).to have_key(:attributes)

      expect(parsed_response[:data][:attributes]).to have_key(:id)
      expect(parsed_response[:data][:attributes]).to have_key(:title)
      expect(parsed_response[:data][:attributes]).to have_key(:vote_average)
      expect(parsed_response[:data][:attributes]).to have_key(:release_year)
      expect(parsed_response[:data][:attributes]).to have_key(:runtime)
      expect(parsed_response[:data][:attributes]).to have_key(:genres)
      expect(parsed_response[:data][:attributes]).to have_key(:summary)
      expect(parsed_response[:data][:attributes]).to have_key(:cast)
      expect(parsed_response[:data][:attributes]).to have_key(:reviews)

      expect(parsed_response[:data][:attributes][:id]).to eq(movie_id)
      expect(parsed_response[:data][:attributes][:title]).to eq("The Lord of the Rings: The Return of the King") 
      expect(parsed_response[:data][:attributes][:vote_average]).to eq(8.482)
    end
  end
end
