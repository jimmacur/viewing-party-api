class Api::V1::MoviesController < ApplicationController
  def index
    movies = Movie.top_rated_movies
    render json: MovieSerializer.new(movies)
  end

  # def search
  #   if params[:query].present?
  #     movies = MovieSearch.new(params[:query]).call
  #     render json: MovieSerializer.new(movies)
  #   else
  #     render json: { error: "Search term missing" }, status: :bad_request
  #   end
  # end
end