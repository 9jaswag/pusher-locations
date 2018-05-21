class TripsController < ApplicationController
  def index
  end

  def new
  end

  def create
    @trip = Trip.new(trip_params)
    render json: @trip if @trip.save
  end

  def show
  end

  def update
  end

  private
    def trip_params
      params.permit(:lat, :long, :name)
    end
end
