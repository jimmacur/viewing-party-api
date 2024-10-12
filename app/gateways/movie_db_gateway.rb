class MovieDbGateway
  MAX_RESULTS = 20

  def top_rated_movies
    response = Faraday.get("https://api.themoviedb.org/3/movie/top_rated", { 
      api_key: Rails.application.credentials.movie_db[:api_key] 
    })
    parsed_response = JSON.parse(response.body, symbolize_names: true)[:results]

    map_movies(parsed_response)
  end

  def movie_search(query)
    response = Faraday.get("https://api.themoviedb.org/3/search/movie", { 
      api_key: Rails.application.credentials.movie_db[:api_key], 
      query: query
    })
    parsed_response = JSON.parse(response.body, symbolize_names: true)[:results]

    map_movies(parsed_response || [])
  end

  private

  def map_movies(movies_data)
    mapped_movies = movies_data.map do |movie_data|
      Movie.new(
        id: movie_data[:id],
        title: movie_data[:title],
        vote_average: movie_data[:vote_average]
      )
    end

    limit_results(mapped_movies)
  end

  def limit_results(movies)
    movies.take(MAX_RESULTS)
  end
end 