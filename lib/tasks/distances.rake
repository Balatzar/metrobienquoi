namespace :distances do
  desc 'Update itineraries with duration from IDF Mobilité API (limited to 5_000)'
  task update: :environment do
    puts "Updating itineraries with duration..."
    start_time = Time.now
    
    itineraries = Itinerary.where(duration: nil).limit(5_000)
    total = itineraries.count
    current = 0
    
    itineraries.find_each do |itinerary|
      current += 1
      progress = (current.to_f / total * 100).round(2)
      print "\rProgress: #{progress}% (#{current}/#{total})"
      
      begin
        start_station = itinerary.start_station
        end_station = itinerary.end_station

        response = IdfMobiliteClient.get_directions(
          origin_lat: start_station.latitude,
          origin_lng: start_station.longitude,
          destination_lat: end_station.latitude,
          destination_lng: end_station.longitude
        )
        
        if response["journeys"].present? && response["journeys"][0].present?
          duration = response["journeys"][0]["duration"] # in seconds
          itinerary.update!(duration: duration)
        else
          puts "\nNo route found for itinerary #{itinerary.id} (#{start_station.name} -> #{end_station.name})"
        end
      rescue => e
        puts "\nError updating itinerary #{itinerary.id}: #{e.message}"
      end
      
      # Add a small delay to respect API rate limits
      sleep 0.1
    end
    
    end_time = Time.now
    duration = (end_time - start_time).round(2)
    puts "\nSuccessfully processed #{total} itineraries in #{duration} seconds!"
  end
end
