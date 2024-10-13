class Api::V1::ViewingPartiesController < ApplicationController
  before_action :authenticate_user, only: [:create, :update]
  
  def create
    gateway = ViewingPartyGateway.new(@current_user, viewing_party_params)
  
    viewing_party = gateway.create_viewing_party
  
    if viewing_party
      if params[:invitee_user_ids].present?
        gateway.add_invitees(viewing_party, params[:invitee_user_ids])
      end
  
      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: { error: viewing_party.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
    viewing_party = ViewingParty.find(params[:id])

    if viewing_party.nil?
      render json: { error: "Viewing party not found" }, status: :not_found
      return
    end

    if viewing_party.host != @current_user
      render json: { error: "You are not authorized to invite users to this viewing party" }, status: :forbidden
      return
    end

    if params[:invitee_user_id].present?
      gateway = ViewingPartyGateway.new(@current_user, {}, params[:invitee_user_id])
      
      if gateway.add_invitees(viewing_party, params[:invitee_user_id])
        render json: ViewingPartySerializer.new(viewing_party), status: :ok
      else
        render json: { error: "Invitee not found" }, status: :not_found
      end
    else
      render json: { error: "No invitee user ID provided" }, status: :unprocessable_entity
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title)
  end

  def authenticate_user
    api_key = params[:api_key]
    @current_user = User.find_by(api_key: api_key) 

    if @current_user.nil?
      render json: { error: "Invalid API key" }, status: :unauthorized
    end
  end
end