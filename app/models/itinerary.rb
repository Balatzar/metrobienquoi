class Itinerary < ApplicationRecord
  belongs_to :start_station, class_name: "Station"
  belongs_to :end_station, class_name: "Station"

  scope :complete, -> { where.not(duration: nil) }
  scope :with_duplicates, -> {
    joins("INNER JOIN itineraries i2 ON itineraries.id < i2.id")
    .where("(itineraries.start_station_id = i2.end_station_id AND itineraries.end_station_id = i2.start_station_id)")
    .select("itineraries.*, i2.id as duplicate_id, i2.start_station_id as duplicate_start, i2.end_station_id as duplicate_end")
  }

  def self.duplicates_to_delete
    # This will return IDs of itineraries that should be deleted
    find_by_sql(<<~SQL)
      WITH duplicates AS (
        SELECT 
          CASE WHEN i1.id < i2.id THEN i1.id ELSE i2.id END as lower_id,
          CASE WHEN i1.id < i2.id THEN i2.id ELSE i1.id END as higher_id,
          CASE WHEN i1.id < i2.id THEN i1.duration ELSE i2.duration END as duration1,
          CASE WHEN i1.id < i2.id THEN i2.duration ELSE i1.duration END as duration2
        FROM itineraries i1
        INNER JOIN itineraries i2 ON i1.start_station_id = i2.end_station_id 
          AND i1.end_station_id = i2.start_station_id
          AND i1.id != i2.id
      )
      SELECT DISTINCT
        CASE
          WHEN duration1 IS NOT NULL AND duration2 IS NULL THEN higher_id
          WHEN duration1 IS NULL AND duration2 IS NOT NULL THEN lower_id
          ELSE higher_id
        END as id_to_delete
      FROM duplicates
    SQL
  end
end
