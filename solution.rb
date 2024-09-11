require "http"
require "json"

puts "Welcome to Umbrella"
puts "What is your current location?"
user_location = gets.chomp

gmaps_key = ENV.fetch("GMAPS_KEY")
gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

raw_response = HTTP.get(gmaps_url)

parsed_gmaps_response = JSON.parse(raw_response)

results_array = parsed_gmaps_response["results"]

result_hash = results_array.at(0)

geometry_hash = result_hash.fetch("geometry")

location_hash = geometry_hash.fetch("location")

latitude = location_hash.fetch("lat")

longitude = location_hash.fetch("lng")

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"

raw_pirate_weather_response = HTTP.get(pirate_weather_url)

parsed_pirate_weather_response = JSON.parse(raw_pirate_weather_response)

currently_hash = parsed_pirate_weather_response.fetch("currently")

current_temp = currently_hash.fetch("temperature")

puts "The temperature at your location is #{current_temp} degrees."
