class Api::V1::ViewingPartiesController < ApplicationController
  before_action :authenticate_user, only: [:create]
  
  def create
    gateway = ViewingPartyGateway.new(@current_user, viewing_party_params, params[:invitees])

    if params[:invitee_user_id].present?
      viewing_party = ViewingParty.find(params[:id])

      if viewing_party.host != @current_user
        render json: { error: "You are not authorized to invite users to this viewing party" }, status: :forbidden
        return  
      end

      if gateway.add_invitees(viewing_party, params[:invitee_user_id])
        render json: ViewingPartySerializer.new(viewing_party)
      else
        render json: { error: "Invitee not found" }, status: :not_found
      end
    else
      result = gateway.create_viewing_party
    
      if result.is_a?(ViewingParty)
        render json: ViewingPartySerializer.new(result), status: :created
      else
        render json: { error: gateway.errors.join(", ") }, status: :unprocessable_entity
      end
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