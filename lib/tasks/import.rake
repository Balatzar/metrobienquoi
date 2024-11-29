require 'csv'

namespace :import do
  desc 'Import stations from CSV file'
  task stations: :environment do
    csv_path = Rails.root.join('db/data/arrets.csv')
    
    puts "Importing stations from #{csv_path}..."
    
    # Delete all existing records to start fresh
    # Delete itineraries first due to foreign key constraints
    Itinerary.delete_all
    Station.delete_all
    
    # Prepare data for bulk insert
    stations_data = []
    
    CSV.foreach(csv_path, headers: true, col_sep: ';', encoding: 'bom|utf-8') do |row|
      # Parse coordinates from ArRGeopoint
      latitude, longitude = row['ArRGeopoint']&.split(',')&.map(&:strip)&.map(&:to_f)

      stations_data << {
        external_id: row['ArRId'],
        version: row['ArRVersion'],
        name: row['ArRName'],
        station_type: row['ArRType'],
        x_coord: row['ArRXEpsg2154'],
        y_coord: row['ArRYEpsg2154'],
        city: row['ArRTown'],
        postal_code: row['ArRPostalRegion'],
        accessibility: row['ArRAccessibility']&.downcase == 'true',
        audible_signals: row['ArRAudibleSignals'],
        visual_signs: row['ArRVisualSigns'],
        fare_zone: row['ArRFareZone'],
        zda_id: row['ZdAId'],
        latitude: latitude,
        longitude: longitude,
        created_at: Time.current,
        updated_at: Time.current
      }

      # Bulk insert every 1000 records to avoid memory issues
      if stations_data.size >= 1000
        Station.insert_all!(stations_data)
        stations_data = []
      end
    end
    
    # Insert all records
    Station.insert_all!(stations_data) if stations_data.any?
    
    puts "Successfully imported #{Station.count} stations!"
  end

  desc 'Generate all possible itineraries between stations'
  task generate_itineraries: :environment do
    puts "Generating itineraries..."
    
    # Delete existing itineraries to start fresh
    Itinerary.delete_all
    
    # Get unique stations by taking the first station of each zda_id group
    stations = Station.metro.group_by(&:zda_id).transform_values(&:first).values
    total_combinations = stations.count * (stations.count - 1)
    current = 0
    
    # Prepare data for bulk insert
    itineraries_data = []
    
    stations.each do |start_station|
      stations.each do |end_station|
        next if start_station.id == end_station.id
        
        current += 1
        progress = (current.to_f / total_combinations * 100).round(2)
        print "\rProgress: #{progress}% (#{current}/#{total_combinations})"
        
        itineraries_data << {
          start_station_id: start_station.id,
          end_station_id: end_station.id,
          created_at: Time.current,
          updated_at: Time.current
        }
        
        # Bulk insert every 1000 records to avoid memory issues
        if itineraries_data.size >= 1000
          Itinerary.insert_all!(itineraries_data)
          itineraries_data = []
        end
      end
    end
    
    # Insert any remaining records
    Itinerary.insert_all!(itineraries_data) if itineraries_data.any?
    
    puts "\nSuccessfully generated #{Itinerary.count} itineraries!"
  end
end
