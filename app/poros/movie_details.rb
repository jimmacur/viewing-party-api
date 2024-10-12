class MovieDetails
  attr_reader :id, :title, :release_date, :vote_average, :runtime, :genres, :overview, :credits, :reviews

  def initialize(movie_data)
    @id = movie_data[:id]
    @title = movie_data[:title]
    @release_date = movie_data[:release_date] 
    @vote_average = movie_data[:vote_average]
    @runtime = movie_data[:runtime] 
    @genres = movie_data[:genres] 
    @summary = movie_data[:overview] 
    @credits = movie_data[:credits] 
    @reviews = movie_data[:reviews] 
  end

  def formatted_runtime
    return nil unless @runtime

    hours = runtime / 60
    minutes = runtime % 60
    "#{hours}h #{minutes}m"
  end

  def limited_reviews
    reviews[:results].take(5).map do |review|
      {
        author: review[:author],
        content: review[:content],
        rating: review[:author_details][:rating]
      }
    end
  end

  def limited_cast
    credits[:cast].take(5).map do |member|
      {
        name: member[:name],
        character: member[:character]
      }
    end
  end

  def release_year
    Date.parse(@release_date).year if @release_date
  end

  def total_reviews
    @reviews[:total_results] || 0
  end
  
  def genres_list
    @genres.map { |genre| genre[:name] if genre.is_a?(Hash) }.compact.join(', ')
  end

  def summary
    @summary
  end
end