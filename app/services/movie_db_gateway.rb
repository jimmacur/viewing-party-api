class MovieDbGateway
  def top_rated_movies
    response = Faraday.get("https://api.themoviedb.org/3/movie/top_rated", { api_key: ENV['MOVIE_DB_API_KEY'] })
    parsed_response = JSON.parse(response.body, symbolize_names: true)

    parsed_response[:results].map do |movie_data|
      Movie.new(
        id: movie_data[:id],
        title: movie_data[:title],
        vote_average: movie_data[:vote_average]
      )
    end
  end
end