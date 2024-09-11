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


hourly_hash = parsed_pirate_weather_response.fetch("hourly")

hourly_data_array = hourly_hash.fetch("data")

next_twelve_hours = hourly_data_array[1..12]

precip_prob_threshold = 0.10

any_precipitation = false

next_twelve_hours.each do |hour_hash|
  precip_prob = hour_hash.fetch("precipProbability")

  if precip_prob > precip_prob_threshold
    any_precipitation = true

    precip_time = Time.at(hour_hash.fetch("time"))

    seconds_from_now = precip_time - Time.now

    hours_from_now = seconds_from_now / 60 / 60

    puts "In #{hours_from_now.round} hours, there is a #{(precip_prob * 100).round}% chance of precipitation."
  end
end

if any_precipitation == true
  puts "You might want to take an umbrella!"
else
  puts "You probably won't need an umbrella."
end
