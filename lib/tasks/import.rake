require 'csv'

namespace :import do
  desc 'Import stations from CSV file'
  task stations: :environment do
    csv_path = Rails.root.join('db/data/trafic-annuel-entrant-par-station-du-reseau-ferre-2021.csv')
    
    puts "Importing stations from #{csv_path}..."
    
    # Delete all existing records to start fresh
    Station.delete_all
    
    # Prepare data for bulk insert
    stations_data = []
    
    CSV.foreach(csv_path, headers: true, col_sep: ';', encoding: 'bom|utf-8') do |row|
      stations_data << {
        rang: row['Rang'],
        reseau: row['Réseau'],
        name: row['Station'],
        trafic: row['Trafic'],
        correspondance_1: row['Correspondance_1'],
        correspondance_2: row['Correspondance_2'],
        correspondance_3: row['Correspondance_3'],
        correspondance_4: row['Correspondance_4'],
        correspondance_5: row['Correspondance_5'],
        ville: row['Ville'],
        arrondissement_pour_paris: row['Arrondissement pour Paris'],
        created_at: Time.current,
        updated_at: Time.current
      }
    end
    
    # Perform bulk insert
    Station.insert_all!(stations_data)
    
    puts "Successfully imported #{Station.count} stations!"
  end
end
