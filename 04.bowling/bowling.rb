#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  case shots
  when s == 'X'
    shots << 10
    shots << 0
  when s == 'G'
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0
frames[0..8].each_with_index do |frame, i|
  if frame == [10, 0] && frames[i + 1][0] == 10
    point += frames[i + 2][0] + 20
  elsif frame == [10, 0]
    point += frames[i + 1][0] + frames[i + 1][1] + 10
  elsif frame.sum == 10 && frame != [10, 0]
    point += frames[i + 1][0] + 10
  else
    point += frame.sum
  end
end
frames[9..11].each do |frame|
  point += frame.sum
end

puts point
