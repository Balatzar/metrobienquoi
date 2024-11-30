require 'uri'
require 'net/http'
require 'json'

class IdfMobiliteClient
  BASE_URL = 'https://prim.iledefrance-mobilites.fr/marketplace/v2/navitia'.freeze

  def self.get_directions(origin_lat:, origin_lng:, destination_lat:, destination_lng:, mode: 'transit')
    uri = URI("#{BASE_URL}/journeys")
    params = {
      from: "#{origin_lng};#{origin_lat}", # Note: IDF Mobilité uses lng;lat format
      to: "#{destination_lng};#{destination_lat}",
      datetime_represents: 'departure',
      datetime: "20241212140000", # December 12th, 2024 at 14:00
      first_section_mode: ['walking'],
      last_section_mode: ['walking'],
      disable_geojson: true
    }
    uri.query = URI.encode_www_form(params)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    request = Net::HTTP::Get.new(uri)
    request['apikey'] = Rails.application.credentials.idf_mobilite_api_key
    
    response = http.request(request)
    JSON.parse(response.body)
  end
end
