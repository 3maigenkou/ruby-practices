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
    output_point(input_str)
    return unless input_str.size > 1

    total_lines_point(input_str)
    total_words_point(input_str)
    total_bytesize_point(input_str)
    print " total\n"

  else
    total_lines_point_nofile(input_str)
    total_words_point_nofile(input_str)
    total_bytesize_point_nofile(input_str)
    print "\n"
  end
end

def output_wc_l(input_str)
  if File.exist?(input_str[0])
    output_point(input_str)
    return unless input_str.size > 1

    total_lines_point(input_str)
    print " total\n"

  else
    total_lines_point_nofile(input_str)
    print "\n"
  end
end

def output_point(file_names)
  options = ARGV.getopts('l')
  file_names.each do |a|
    file = File.read(a)
    file_lines = file.count("\n").to_s.rjust(8)
    words = file.split(/\s+/).size.to_s.rjust(7)
    bytesize = file.bytesize.to_s.rjust(7)
    name = File.basename(a)
    if options['l']
      puts "#{file_lines} #{name}"
    else
      puts "#{file_lines} #{words} #{bytesize} #{name}"
    end
  end
end

def total_lines_point(file_names)
  total_file_lines = file_names.sum { |a| File.read(a).count("\n") }
  print total_file_lines.to_s.rjust(8)
end

def total_words_point(file_names)
  total_file_words = file_names.sum { |a| File.read(a).split(/\s+/).size }
  print total_file_words.to_s.rjust(8)
end

def total_bytesize_point(file_names)
  total_file_bytesize = file_names.sum { |a| File.read(a).bytesize }
  print total_file_bytesize.to_s.rjust(8)
end

def total_lines_point_nofile(input_str)
  print input_str.size.to_s.rjust(8)
end

def total_words_point_nofile(input_str)
  total_file_words_nofile = input_str.sum { |a| a.split(/\s+/).size }
  print total_file_words_nofile.to_s.rjust(8)
end

def total_bytesize_point_nofile(input_str)
  total_file_bytesize_nofile = input_str.sum(&:bytesize)
  print total_file_bytesize_nofile.to_s.rjust(8)
end

main
