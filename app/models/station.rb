class Station < ApplicationRecord
  has_many :start_itineraries, class_name: 'Itinerary', foreign_key: 'start_station_id'
  has_many :end_itineraries, class_name: 'Itinerary', foreign_key: 'end_station_id'
  has_and_belongs_to_many :searches

  validates :external_id, presence: true

  scope :metro, -> { where(station_type: "metro") }
  scope :bus, -> { where(station_type: "bus") }
  scope :tram, -> { where(station_type: "tram") }
  scope :rail, -> { where(station_type: "rail") }
end
