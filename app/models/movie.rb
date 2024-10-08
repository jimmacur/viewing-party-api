class Movie
  attr_reader :id, :title, :vote_average

  def initialize(id:, title:, vote_average:)
    @id = id.to_s
    @title = title
    @vote_average = vote_average
  end
  
  def self.top_rated
    response = Faraday.get('https://api.themoviedb.org/3/movie/top_rated')
    results = JSON.parse(response.body, symbolize_names: true)[:results].first(20)

    results.map do |result|
      Movie.new(
        id: result[:id],            
        title: result[:title],
        vote_average: result[:vote_average]
      )
    end
  end
end