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
    render json: UserSerializer.new(@current_user)
  end
  
  private
  
  def user_params
    params.permit(:name, :username, :password, :password_confirmation)
  end
  
  def validate_api_key
    api_key = params[:api_key]
    @current_user = User.find_by(id: params[:id])

    if @current_user.nil?
      render json: { message: 'User not found', status: 404 }, status: :not_found
      return
    elsif api_key != @current_user.api_key
      render json: { message: 'Unauthorized', status: 401 }, status: :unauthorized
      return
    end
  end
end