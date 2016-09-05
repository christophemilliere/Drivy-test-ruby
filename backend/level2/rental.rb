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
    time_price + car.price_per_km * distance
  end

  def to_hash
    {
      :id => id,
      :price => total_price
    }
  end

  private
    # final price
    def time_price
      price = 0
      days.downto(1) do |day|
        discount = 0
        if day > 10
          discount = 50
        elsif day > 4
          discount = 30
        elsif day > 1
          discount = 10
        end

        price += car.price_per_day - (car.price_per_day * discount / 100)
      end

      return price
    end
end
