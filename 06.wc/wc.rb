#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l')
  input_str = ARGV.empty? ? $stdin.readlines.map(&:chomp) : ARGV
  options['l'] ? output_wc_l(input_str) : output_wc(input_str)
end

def output_wc(input_str)
  if File.exist?(input_str[0])
    input_str.each do |a|
      file = File.read(a)
      file_lines = file.count("\n").to_s.rjust(8)
      words = file.split(/\s+/).size.to_s.rjust(7)
      bytesize = file.bytesize.to_s.rjust(7)
      name = File.basename(a)
      puts "#{file_lines} #{words} #{bytesize} #{name}"
    end
    return unless input_str.size > 1

    total_lines_point(input_str)
    total_words_point(input_str)
    total_bytesize_point(input_str)
    print " total\n"

  else
    puts "wc: #{input_str}: open: No such file or directory"
  end
end

def output_wc_l(input_str)
  if File.exist?(input_str[0])
    input_str.each do |a|
      file = File.read(a)
      file_lines = file.count("\n").to_s.rjust(8)
      name = File.basename(a)
      puts "#{file_lines} #{name}"
    end
    return unless input_str.size > 1

    total_lines_point(input_str)
    print " total\n"

  else
    puts "wc: #{input_str}: open: No such file or directory"
  end
end

def total_lines_point(input_str)
  total_file_lines = []
  input_str.each do |a|
    file = File.read(a)
    total_file_lines << file.count("\n")
  end
  print total_file_lines.inject(:+).to_s.rjust(8)
end

def total_words_point(input_str)
  total_file_words = []
  input_str.each do |a|
    file = File.read(a)
    words = file.split(/\s+/)
    total_file_words << words.size
  end
  print total_file_words.inject(:+).to_s.rjust(8)
end

def total_bytesize_point(input_str)
  total_file_bytesize = []
  input_str.each do |a|
    file = File.read(a)
    total_file_bytesize << file.bytesize
  end
  print total_file_bytesize.inject(:+).to_s.rjust(8)
end



main
