class CheckinsController < ApplicationController
  def create
    @checkin = Checkin.new(checkin_params)

    render json: @checkin.as_json(only: [:lat, :lng, :trip_id]) if @checkin.save
  end

  private
    def checkin_params
      params.permit(:trip_id, :lat, :lng)
    end
end
