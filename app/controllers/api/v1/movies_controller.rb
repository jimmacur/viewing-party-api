class Api::V1::MoviesController < ApplicationController
  def index
    movies = Movie.top_rated_movies
    render json: MovieSerializer.new(movies)
  end
end