# require_relative '../../../services/movie_db_gateway'

class Api::V1::MoviesController < ApplicationController
  def index
    movies = MovieDbGateway.new.top_rated_movies
    render json: MovieSerializer.new(movies)
  end
end