class Api::V1::MoviesController < ApplicationController
  def index
    if params[:query].present?
      movies = MovieDbGateway.new.movie_search(params[:query])
    else
      movies = MovieDbGateway.new.top_rated_movies
    end
    render json: MovieSerializer.new(movies)
  end

  def show
    movie = MovieService.new(params[:id]).call
    render json: MovieDetailsSerializer.new(movie).serializable_hash
  end
end