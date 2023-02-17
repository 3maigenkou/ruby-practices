# frozen_string_literal: true

require './shot'

class Frame
  STRIKE_POINT = 10

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    [@first_shot.score, @second_shot.score].sum == 10 && @first_shot.score != 10
  end

  def score
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def first_shot_score
    @first_shot.score
  end

  def second_shot_score
    @second_shot.score
  end
end
