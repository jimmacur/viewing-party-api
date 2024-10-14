class Api::V1::ViewingPartiesController < ApplicationController
  before_action :authenticate_user, only: [:create, :update]
  before_action :set_viewing_party, only: [:update]

  def create
    gateway = ViewingPartyGateway.new(@current_user, viewing_party_params, params[:invitees])

    result = gateway.create_viewing_party

    if result.is_a?(ViewingParty)
      render json: ViewingPartySerializer.new(result), status: :created
    else
      render json: { error: gateway.errors.join(", ") }, status: :unprocessable_entity
    end
  end

  def update
    if @viewing_party.host != @current_user
      render json: { error: "You are not the host of this viewing party" }, status: :unauthorized
      return
    end

    invitees = params[:invitees] || []

    invitees.each do |invitee_id|
      user = User.find_by(id: invitee_id)
      if user.nil?
        render json: { error: "User with id #{invitee_id} not found" }, status: :not_found
        return
      end

      Invitation.create(viewing_party: @viewing_party, user: user)
    end

    render json: ViewingPartySerializer.new(@viewing_party)
  end

  private

  def set_viewing_party
    @viewing_party = ViewingParty.find(params[:id])
  end

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