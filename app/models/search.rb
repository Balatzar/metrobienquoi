class Search < ApplicationRecord
  has_and_belongs_to_many :stations

  def nearby_stations(limit: 5)
    return [] if stations.size < 2

    # Get all itineraries connected to our stations
    itineraries = Itinerary
      .complete
      .where("start_station_id IN (:station_ids) OR end_station_id IN (:station_ids)", station_ids: stations.pluck(:id))
      .includes(:start_station, :end_station)

    # Build a hash of connected stations and their itineraries
    stations_with_itineraries = {}

    itineraries.each do |itinerary|
      connected_station = if stations.pluck(:id).include?(itinerary.start_station_id)
        itinerary.end_station
      else
        itinerary.start_station
      end

      # Skip if it's one of our selected stations
      next if stations.pluck(:id).include?(connected_station.id)

      # Initialize the hash entry if it doesn't exist
      stations_with_itineraries[connected_station.id] ||= {
        station: connected_station,
        itineraries: [],
        total_duration: 0
      }

      # Add this itinerary to the station's list
      stations_with_itineraries[connected_station.id][:itineraries] << itinerary
      stations_with_itineraries[connected_station.id][:total_duration] += itinerary.duration
    end

    # Calculate average duration and sort by it
    stations_with_itineraries.values.each do |entry|
      entry[:average_duration] = entry[:total_duration].to_f / entry[:itineraries].size
    end

    stations_with_itineraries
      .values
      .sort_by { |entry| entry[:average_duration] }
      .first(limit)
  end
end
