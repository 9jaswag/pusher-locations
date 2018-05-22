class TripsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.checkins.build(lat: params[:lat], lng: params[:lng])

    render json: @trip.as_json if @trip.save
  end

  def show
    @trip = Trip.find_by(uuid: params[:id])
    # byebug
  end

  def update
  end

  private
    def trip_params
      params.permit(:name)
    end
end
