class Itinerary < ApplicationRecord
  belongs_to :start_station, class_name: 'Station'
  belongs_to :end_station, class_name: 'Station'

  scope :complete, -> { where.not(distance: nil, duration: nil) }
end
