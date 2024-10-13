class Api::V1::ViewingPartiesController < ApplicationController
  before_action :authenticate_user, only: [:create]
  
  def create
    viewing_party = ViewingParty.new(viewing_party_params.except(:api_key))
    viewing_party.host = @current_user

    if viewing_party.save
      params[:invitees].each do |invitee_id|
        user = User.find_by(id: invitee_id)
        if user
          Invitation.create(viewing_party: viewing_party, user: user)
        end
      end

      render json: ViewingPartySerializer.new(viewing_party), status: :created
    else
      render json: { error: viewing_party.errors.full_messages.to_sentence }, status: :unprocessable_entity
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