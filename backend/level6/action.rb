class Action
  attr_accessor :who, :type, :amount

  def initialize(who, type, amount)
    @who = who
    @type = type
    @amount = amount
  end

  def different(object)

    return raise 'Oh NON' if type != object.type

    diff_amount = object.amount - amount

    if object.type == 'credit'
      if diff_amount < 0
        @amount = diff_amount.abs
      else
        @amount = diff_amount.abs
      end
    else
      if diff_amount > 0
        @amount = diff_amount.abs
      else
        @amount = diff_amount.abs
      end
    end
    {
      :who => @who,
      :type => @type,
      :amount => @amount
    }
  end

  def to_hash
    {
      :who => who,
      :type => type,
      :amount => amount
    }
  end
end
