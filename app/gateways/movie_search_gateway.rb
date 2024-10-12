class MovieSearchGateway
  def initialize(movie_id)
    @movie_id = movie_id
    @base_url = "https://api.themoviedb.org/3/movie/#{@movie_id}"
    @api_key = Rails.application.credentials.movie_db[:api_key]
  end

  def call
    movie_data = fetch_movie_cast_and_reviews
    return nil unless movie_data

    {
      id: movie_data[:id],
      title: movie_data[:title],
      release_date: movie_data[:release_date],
      vote_average: movie_data[:vote_average],
      runtime: movie_data[:runtime],
      genres: movie_data[:genres].map { |genre| genre[:name] },
      overview: movie_data[:overview], 
      credits: movie_data[:credits],
      reviews: movie_data[:reviews]
    }
  end

  private

  def fetch_movie_cast_and_reviews
    response = Faraday.get("#{@base_url}?api_key=#{@api_key}&append_to_response=credits,reviews")
    parse_response(response)
  end

  def parse_response(response)
    JSON.parse(response.body, symbolize_names: true) if response.success?
  end
end