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
    movie_data = MovieSearchGateway.new(params[:id]).call
    if movie_data
      movie_details = MovieDetails.new(movie_data)
      render json: MovieDetailsSerializer.new(movie_details).serializable_hash
    else
      render json: { error: 'Movie not found' }, status: 404
    end
  end
end