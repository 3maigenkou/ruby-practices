require "./shot"

class Frame
  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    [@first_shot.score,@second_shot.score].sum == 10 && @first_shot != "X"
  end

  def score
   [@first_shot.score,@second_shot.score,@third_shot.score].sum
  end

  def strike_point
    @strike_point = 10
  end

  def spare_point
    @spare_point = 10
  end

  def double_strike_bonus
    @first_shot.score + strike_point*2
  end

  def strike_bonus
    @first_shot.score + @second_shot.score + strike_point
  end

  def spare_bonus
    @first_shot.score + spare_point
  end
end
