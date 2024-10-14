class Api::V1::MoviesController < ApplicationController
  def index
    if params[:query].present?
      query = params[:query]
      movies = MovieDbGateway.new.movie_search(query)

      if movies.empty?
        render json: { message: 'No movies found' }, status: :ok
      else
        render json: MovieSerializer.new(movies).serializable_hash, status: :ok
      end

    else
      movies = MovieDbGateway.new.top_rated_movies
      render json: MovieSerializer.new(movies).serializable_hash, status: :ok
    end
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