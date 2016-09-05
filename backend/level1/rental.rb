require 'date'

class Rental
  attr_accessor :id, :days, :distance, :car

  def initialize(id, car:, start_date:, end_date:, distance:)
    @id = id
    @car = car

    start_at = Date.parse(start_date)
    end_at = Date.parse(end_date)
    @days = (end_at - start_at).to_i + 1
    @distance = distance
  end

  def total_price
    car.price_per_day * days + car.price_per_km * distance
  end

  def to_hash
    {
      id:id,
      price: total_price
    }
  end
end
