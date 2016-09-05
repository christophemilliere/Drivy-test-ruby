
require "json"
require "./car"
require "./rental"

file = File.new 'data.json', 'r'
data = JSON.load(file)

rentals = []
cars = []

# Create cars
data['cars'].each do |info|
  cars[info['id']] = Car.new(info['id'], price_per_day: info['price_per_day'], price_per_km: info['price_per_km'])
end

# rentals
data['rentals'].each do |info|
  rental = Rental.new(info['id'], car: cars[info['car_id']], start_date: info['start_date'], end_date: info['end_date'], distance: info['distance'], deductible_reduction: info['deductible_reduction'])
  rentals << rental.to_hash
end

# output
output = File.new 'outputs.json', 'w'
output.write JSON.pretty_generate({ rentals: rentals })
