class Api::V1::MoviesController < ApplicationController
  def index
    movies = Movie.top_rated
    render json: MovieSerializer.new(movies)
  end
end
