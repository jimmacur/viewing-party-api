require 'rails_helper'

RSpec.describe "Api::V1::Movies", type: :request do
  describe "GET /api/v1/movies" do
    it 'returns top rated movies' do
      json_response = File.read('spec/fixtures/top_rated_movies.json')
      stub_request(:get, "https://api.themoviedb.org/3/movie/top_rated")
        .to_return(status: 200, body: json_response)

      get '/api/v1/movies'

      expect(response).to be_successful

      movies = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(movies.count).to eq(20)
      expect(movies.first[:attributes][:title]).to eq("The Shawshank Redemption")
      expect(movies.first[:attributes][:vote_average]).to eq(8.707)
    end
  end
end
