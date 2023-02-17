# frozen_string_literal: true

require './shot'
require './frame'

class Game
  def initialize(marks)
    @marks = marks
  end

  def split_marks
    shot_count = 0
    shots = []
    @marks.split(',').each do |mark|
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

  def frames
    shots_nomal_frames = split_marks[0..17].each_slice(2).to_a
    shots_last_frames = [split_marks[18..20]]
    total_shots = shots_nomal_frames.concat shots_last_frames
    frames = []
    total_shots.each do |shot|
      frames << Frame.new(shot[0], shot[1], shot[2])
    end
    frames
  end

  def spare_bonus_point
    spare_bonus_point = 0
    frames.each_with_index do |frame, idx|
      next unless idx < 9

      spare_bonus_point += frames[idx + 1].first_shot_score if frame.spare?
    end
    spare_bonus_point
  end

  def strike_bonus_point
    strike_bonus_point = 0
    frames.each_with_index do |frame, idx|
      next unless idx < 9

      if idx == 8 && frame.strike?
        strike_bonus_point += frames[idx + 1].first_shot_score + frames[idx + 1].second_shot_score
      elsif frame.strike? && frames[idx + 1].strike?
        strike_bonus_point += frames[idx + 2].first_shot_score + Frame::STRIKE_POINT
      elsif frame.strike?
        strike_bonus_point += frames[idx + 1].score
      end
    end
    strike_bonus_point
  end

  def score_non_bonus
    score_non_bonus = 0
    frames.each do |frame|
      score_non_bonus += frame.score
    end
    score_non_bonus
  end

  def score
    score_non_bonus + spare_bonus_point + strike_bonus_point
  end
end
