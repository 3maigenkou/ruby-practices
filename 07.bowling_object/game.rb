# frozen_string_literal: true

require './shot'
require './frame'

class Game
  def initialize(marks)
    shot_count = 0
    frames = []
    marks[0].split(',').each do |mark|
      frames << mark
      if shot_count < 18 && mark == 'X'
        frames << nil
        shot_count += 2
      elsif shot_count < 18
        shot_count += 1
      end
    end
    @frame1 = Frame.new(frames[0], frames[1])
    @frame2 = Frame.new(frames[2], frames[3])
    @frame3 = Frame.new(frames[4], frames[5])
    @frame4 = Frame.new(frames[6], frames[7])
    @frame5 = Frame.new(frames[8], frames[9])
    @frame6 = Frame.new(frames[10], frames[11])
    @frame7 = Frame.new(frames[12], frames[13])
    @frame8 = Frame.new(frames[14], frames[15])
    @frame9 = Frame.new(frames[16], frames[17])
    @frame10 = Frame.new(frames[18], frames[19], frames[20])
  end

  def score
    frames = [@frame1, @frame2, @frame3, @frame4, @frame5, @frame6, @frame7, @frame8, @frame9, @frame10]
    frame_count = 0
    total_score = 0
    frames.each_with_index do |frame, i|
      if frame_count == 8 && frame.strike?
        total_score += frames[i + 1].strike_bonus
        frame_count += 1
      elsif frame_count < 9 && frame.strike? && frames[i + 1].strike?
        total_score += frames[i + 2].double_strike_bonus
        frame_count += 1
      elsif frame_count < 9 && frame.strike?
        total_score += frames[i + 1].strike_bonus
        frame_count += 1
      elsif frame_count < 9 && frame.spare?
        total_score += frames[i + 1].spare_bonus
        frame_count += 1
      elsif frame_count < 9
        total_score += frame.score
        frame_count += 1
      else
        total_score += frame.score
      end
    end
    p total_score
  end
end
