# frozen_string_literal: true

require 'optparse'
require_relative 'option_l'

DISPLAY_NUMBER = 3

class FilesData
  def initialize
    @options = ARGV.getopts('a', 'r', 'l')
    @files_name = @options['a'] ? Dir.glob('*', File::FNM_DOTMATCH).sort : Dir.glob('*').sort
    @files_name = @files_name.reverse if @options['r']
  end

  def self.output
    new.output
  end

  def output
    @options['l'] ? OptionL.new(@files_name).output : display_except_option_l
  end

  private

  def adjust_display
    files = @files_name.dup
    files << nil while (files.size % DISPLAY_NUMBER).positive?
    files_ljust = files.map { |file| file.to_s.ljust(20) }
    files_ljust.each_slice(files.size / DISPLAY_NUMBER).to_a.transpose
  end

  def display_except_option_l
    puts adjust_display.map(&:join)
  end
end
