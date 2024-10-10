class Api::V1::MoviesController < ApplicationController
  def index
    top_rated_movies = Movie.top_rated_movies
    render json: MovieSerializer.new(top_rated_movies), status: :ok
  end
end