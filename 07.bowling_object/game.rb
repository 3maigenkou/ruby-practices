# frozen_string_literal: true

require_relative 'frame'

class Game
  def score
    non_bonus_point + strike_bonus_point + spare_bonus_point
  end

  private

  def initialize(marks)
    @summary_shots = summary_shots(marks)
    shots = split_marks(marks)
    @frames = make_frames(shots)
  end

  def split_marks(marks)
    shot_count = 0
    shots = []
    marks.split(',').each do |mark|
      shots << mark
      if shot_count < 18 && mark == 'X'
        shots << nil
        shot_count += 2
      elsif shot_count < 18
        shot_count += 1
      end
    end
    shots
  end

  def summary_shots(marks)
    marks.split(',').map do |mark|
      Shot.new(mark)
    end
  end

  def make_frames(shots)
    shots_nomal_frames = shots[0..17].each_slice(2).to_a
    shots_last_frames = [shots[18..20]]
    total_shots = shots_nomal_frames.concat shots_last_frames
    total_shots.map do |shot|
      Frame.new(shot[0], shot[1], shot[2])
    end
  end

  def strike_bonus_point
    strike_bonus_point = 0
    shot_times = @summary_shots.length
    @summary_shots.each_with_index do |shot, idx|
      strike_bonus_point += @summary_shots[idx + 1].shot_point + @summary_shots[idx + 2].shot_point if shot.strike? && idx <= shot_times - 3
    end
    strike_bonus_point
  end

  def spare_bonus_point
    spare_bonus_point = 0
    @frames.each_with_index do |frame, idx|
      if idx == 9 && frame.spare?
        spare_bonus_point += frame.third_shot_point
      elsif frame.spare?
        spare_bonus_point += @frames[idx + 1].first_shot_point
      end
    end
    spare_bonus_point
  end

  def non_bonus_point
    non_bonus_point = 0
    @frames.each_with_index do |frame, idx|
      non_bonus_point += if idx == 9 && frame.spare? || frame.strike?
                           10
                         else
                           frame.frame_point
                         end
    end
    non_bonus_point
  end
end
