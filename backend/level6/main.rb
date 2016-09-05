require "json"
require "./car"
require "./rental"

file = File.new 'data.json', 'r'
datas = JSON.load(file)

rentals = []
cars = []
modifications = []

# Create cars
datas['cars'].each do |c|
  cars[c['id']] = Car.new(c['id'], price_per_day: c['price_per_day'], price_per_km: c['price_per_km'])
end

# rentals
datas['rentals'].each do |r|
  rental = Rental.new(r['id'], cars[r['car_id']], r['start_date'], r['end_date'], r['distance'], r['deductible_reduction'])
  rentals[r['id']] = rental
end

# modifications
datas['rental_modifications'].each do |rm|
  rental = rentals[rm['rental_id']]

  start_date = rm.include?('start_date') ? rm['start_date'] : rental.start_date
  end_date = rm.include?('end_date') ? rm['end_date'] : rental.end_date
  distance = rm.include?('distance') ? rm['distance'] : rental.distance

  # update
  modification_actions = rental.modification_rental(start_date, end_date, distance)

  modifications << {
    id: rm['id'],
    rental_id: rm['rental_id'],
    actions: modification_actions.map! { |a| a.to_hash }
  }

end

# output
output = File.new 'outputs.json', 'w'
output.write JSON.pretty_generate({ rental_modifications: modifications })
