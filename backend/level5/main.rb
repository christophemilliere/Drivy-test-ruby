
require "json"
require "./car"
require "./rental"

file = File.new 'data.json', 'r'
datas = JSON.load(file)

rentals = []
cars = []

# Create cars
datas['cars'].each do |c|
  cars[c['id']] = Car.new(c['id'], price_per_day: c['price_per_day'], price_per_km: c['price_per_km'])
end

# rentals
datas['rentals'].each do |r|
  rental = Rental.new(r['id'], car: cars[r['car_id']], start_date: r['start_date'], end_date: r['end_date'], distance: r['distance'], deductible_reduction: r['deductible_reduction'])

  # the driver must pay the rental price and the (optional) deductible reduction
  # rentals << rental.to_hash

  rentals << {
    id: r['id'],
    actions: rental.actions.map!{ |a| a.to_hash }
  }
end

# output
output = File.new 'outputs.json', 'w'
output.write JSON.pretty_generate({ rentals: rentals })
