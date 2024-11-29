namespace :distances do
  desc 'Update itineraries with distance and duration from Google Maps (limited to 5)'
  task update: :environment do
    puts "Updating itineraries with distance and duration..."
    
    itineraries = Itinerary.where(distance: nil, duration: nil).limit(500)
    total = itineraries.count
    current = 0
    
    itineraries.find_each do |itinerary|
      current += 1
      progress = (current.to_f / total * 100).round(2)
      print "\rProgress: #{progress}% (#{current}/#{total})"
      
      begin
        start_station = itinerary.start_station
        end_station = itinerary.end_station

        directions = GmapClient.get_directions(
          origin_lat: start_station.latitude,
          origin_lng: start_station.longitude,
          destination_lat: end_station.latitude,
          destination_lng: end_station.longitude
        )
        
        if directions["routes"].present? && directions["routes"][0]["legs"].present?
          leg = directions["routes"][0]["legs"][0]
          
          itinerary.update!(
            distance: leg["distance"]["value"], # in meters
            duration: leg["duration"]["value"]  # in seconds
          )
        else
          puts "\nNo route found for itinerary #{itinerary.id} (#{start_station.name} -> #{end_station.name})"
          puts "Response: #{directions.inspect}"
        end
      rescue => e
        puts "\nError updating itinerary #{itinerary.id}: #{e.message}"
      end
      
      # Add a small delay to respect API rate limits
      sleep 0.1
    end
    
    puts "\nSuccessfully processed #{total} itineraries!"
  end
end
