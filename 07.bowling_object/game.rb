# frozen_string_literal: true

require './shot'
require './frame'

class Game
  def initialize(marks)
    shot_count = 0
    shots = []
    marks[0].split(',').each do |mark|
      shots << mark
      if shot_count < 18 && mark == 'X'
        shots << nil
        shot_count += 2
      elsif shot_count < 18
        shot_count += 1
      end
    end
    @frame1 = Frame.new(shots[0], shots[1])
    @frame2 = Frame.new(shots[2], shots[3])
    @frame3 = Frame.new(shots[4], shots[5])
    @frame4 = Frame.new(shots[6], shots[7])
    @frame5 = Frame.new(shots[8], shots[9])
    @frame6 = Frame.new(shots[10], shots[11])
    @frame7 = Frame.new(shots[12], shots[13])
    @frame8 = Frame.new(shots[14], shots[15])
    @frame9 = Frame.new(shots[16], shots[17])
    @frame10 = Frame.new(shots[18], shots[19], shots[20])
  end

  def score
    frames = [@frame1, @frame2, @frame3, @frame4, @frame5, @frame6, @frame7, @frame8, @frame9, @frame10]
    total_score = 0
    frames.each_with_index do |frame, frame_count|
      total_score += if frame_count == 8 && frame.strike?
                       frames[frame_count + 1].strike_bonus
                     elsif frame_count < 9 && frame.strike? && frames[frame_count + 1].strike?
                       frames[frame_count + 2].double_strike_bonus
                     elsif frame_count < 9 && frame.strike?
                       frames[frame_count + 1].strike_bonus
                     elsif frame_count < 9 && frame.spare?
                       frames[frame_count + 1].spare_bonus
                     elsif frame_count < 9
                       frame.score
                     else
                       frame.score
                     end
    end
    p total_score
  end
end
