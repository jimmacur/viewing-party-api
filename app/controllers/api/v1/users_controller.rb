class Api::V1::UsersController < ApplicationController

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
    validate_api_key
    render json: UserSerializer.new(@current_user)
  end

  private

  def user_params
    params.permit(:name, :username, :password, :password_confirmation)
  end

  def validate_api_key
    api_key = params[:api_key]
    @current_user = User.find_by(api_key: api_key)
    
    if @current_user.nil?
      render json: { message: 'User not found', status: 401 }, status: :not_found
      return
    end
  
    unless @current_user.id.to_s == params[:id]
      render json: { message: 'Unauthorized', status: 404 }, status: :unauthorized
      return
    end
  end
end