# frozen_string_literal: true

require 'optparse'
require_relative 'option_l'

DISPLAY_NUMBER = 3

class FilesData
  def self.output(options = nil)
    new.output(options)
  end

  def output(_options = nil)
    @options['l'] ? display_option_l : display_except_option_l
  end

  # private

  def initialize(_options = nil)
    @options = ARGV.getopts('a', 'r', 'l')
    @files_name = @options['a'] ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
    @files_name = @files_name.reverse if @options['r']
    @files_data = @files_name.map { |data| File::Stat.new(data) } if @options['l']
  end

  def adjust_display
    @files_name << nil while (@files_name.size % DISPLAY_NUMBER).positive?
    files_ljust = @files_name.map { |a| a.to_s.ljust(16) }
    files_ljust.each_slice(@files_name.size / DISPLAY_NUMBER).to_a.transpose
  end

  def display_except_option_l
    adjust_display.each { |row| puts row.join }
  end

  def display_option_l
    p @files_data
  end


end
