class Movie < ApplicationRecord
  def self.top_rated_movies
    response = Faraday.get("https://api.themoviedb.org/3/movie/top_rated", { api_key: ENV['MOVIE_DB_API_KEY'] })
    parsed_response = JSON.parse(response.body, symbolize_names: true)

    parsed_response[:results].map do |movie|
      {
        title: movie[:title],
        vote_average: movie[:vote_average]
      }
    end
  end
end