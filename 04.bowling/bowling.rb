#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
STRIKE_POINT = 10
SPARE_POINT = 10
GUTTER_POINT = 0

scores.each do |s|
  case s
  when "X"
    shots << STRIKE_POINT
    shots << 0
  when "G"
    shots << GUTTER_POINT
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

point = 0
frames[0..8].each_with_index do |frame, i|
  if frame == [10, 0] && frames[i + 1][0] == STRIKE_POINT
    point += frames[i + 2][0] + STRIKE_POINT*2
  elsif frame == [10, 0]
    point += frames[i + 1][0] + frames[i + 1][1] + STRIKE_POINT
  elsif frame.sum == SPARE_POINT && frame != [10, 0]
    point += frames[i + 1][0] + SPARE_POINT
  else
    point += frame.sum
  end
end
frames[9..11].each do |frame|
  point += frame.sum
end

puts point
