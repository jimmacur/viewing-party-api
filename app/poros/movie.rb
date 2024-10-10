class Movie
  attr_reader :id, :title, :vote_average

  def initialize(id:, title:, vote_average:)
    @id = id.to_s
    @title = title
    @vote_average = vote_average
  end
end