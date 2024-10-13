class Api::V1::UsersController < ApplicationController
  before_action :validate_api_key, only: [:show]

  def create
    user = User.new(user_params)
    if user.save
      render json: UserSerializer.new(user), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(user.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  def index
    render json: UserSerializer.format_user_list(User.all)
  end

  def show
    user = User.find(params[:id])
    if user
      render json: UserSerializer.new(user)
    else
      render json: { message: 'User not found', status: 404 }, status not_found
    end
  end

  private

  def user_params
    params.permit(:name, :username, :password, :password_confirmation)
  end

  def validate_api_key
    user = User.find_by(api_key: params[:api_key])
    if user.nil? || user.api_key != params[:api_key]
      render json: { message: 'Unauthorized', status: 401 }, status: :unauthorized
    end
  end
end