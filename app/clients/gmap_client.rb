require "uri"
require "net/http"
require "json"

class GmapClient
  BASE_URL = "https://maps.googleapis.com/maps/api/directions/json".freeze

  def self.get_directions(origin_lat:, origin_lng:, destination_lat:, destination_lng:, mode: "transit")
    uri = URI(BASE_URL)
    params = {
      origin: "#{origin_lat},#{origin_lng}",
      destination: "#{destination_lat},#{destination_lng}",
      mode: mode,
      key: Rails.application.credentials.google_maps_api_key,
      region: "fr",
      types: "transit_station",
      transit_mode: "subway"
    }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end
end
