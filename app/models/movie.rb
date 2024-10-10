class Movie
  def self.top_rated_movies
    response = Faraday.get("https://api.themoviedb.org/3/movie/top_rated", { api_key: ENV['MOVIE_DB_API_KEY'] })
    parsed_response = JSON.parse(response.body, symbolize_names: true)

    parsed_response[:results].map do |movie_data|
      OpenStruct.new(
        id: movie_data[:id].to_s,
        title: movie_data[:title],
        vote_average: movie_data[:vote_average]
      )
    end
  end
end