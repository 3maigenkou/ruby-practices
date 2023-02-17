# frozen_string_literal: true

require './shot'
require './frame'
require './game'

game = Game.new(ARGV[0])
p game.score
