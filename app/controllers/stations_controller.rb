class StationsController < ApplicationController
  def show
    station = Station.find(params[:id])
    render json: {
      id: station.id,
      name: station.name,
      city: station.city,
      latitude: station.latitude,
      longitude: station.longitude,
      station_type: station.station_type
    }
  end
end
