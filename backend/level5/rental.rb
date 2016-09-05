require 'date'
require './action'

class Rental
  attr_accessor :id, :days, :distance, :car, :deductible_reduction

  def initialize(id, car:, start_date:, end_date:, distance:, deductible_reduction:)
    @id = id
    @car = car

    start_at = Date.parse(start_date)
    end_at = Date.parse(end_date)
    @days = (end_at - start_at).to_i + 1
    @distance = distance
    @deductible_reduction = deductible_reduction
  end

  def total_price
    time_price + car.price_per_km * distance
  end

  def commission_amount
    total_price * 30 / 100
  end

  def insurance_fee
    commission_amount / 2
  end

  def assistance_fee
    days * 100
  end

  def drivy_fee
    commission_amount - insurance_fee - assistance_fee
  end

  def deductible_reduction_fee
    @deductible_reduction ? 400 * @days : 0
  end

  # actions
  def actions
    return [
      action_who('driver'),
      action_who('owner'),
      action_who('insurance'),
      action_who('assistance'),
      action_who('drivy')
    ]
  end

  def action_who(who)
    case who
    when 'driver'
      Action.new('driver','debit', total_price + deductible_reduction_fee)
    when 'owner'
      Action.new('owner','credit', total_price - commission_amount)
    when 'insurance'
      Action.new('insurance', 'credit',insurance_fee)
    when 'assistance'
      Action.new('assistance', 'credit', assistance_fee)
    when 'drivy'
      Action.new('drivy', 'credit', drivy_fee + deductible_reduction_fee)
    else
      raise 'Rien trouvé'
    end
  end

  def to_hash
    return {
      :id => id,
      :price => total_price,
      options: {
        deductible_reduction: deductible_reduction_fee
      },
      commission: {
        insurance_fee: insurance_fee,
        assistance_fee: assistance_fee,
        drivy_fee: drivy_fee
      }
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
