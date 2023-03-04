# frozen_string_literal: true

require_relative 'shot'

class Frame
  STRIKE_POINT = 10
  SPARE_POIMT = 10

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def strike?
    @first_shot.strike?
  end

  def spare?
    [@first_shot.shot_point, @second_shot.shot_point].sum == STRIKE_POINT && !strike?
  end

  def frame_point
    [@first_shot.shot_point, @second_shot.shot_point, @third_shot.shot_point].sum
  end

  def first_shot_point
    @first_shot.shot_point
  end

  def second_shot_point
    @second_shot.shot_point
  end

  def third_shot_point
    @third_shot.shot_point
  end
end
