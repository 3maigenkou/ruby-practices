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
    input_str.each_with_index do |_, i|
      line = lines_point(input_str)[i].to_s.rjust(8)
      word = words_point(input_str)[i].to_s.rjust(8)
      bytesize = bytesize_point(input_str)[i].to_s.rjust(8)
      name = file_name(input_str)[i]
      puts "#{line}#{word}#{bytesize} #{name}"
    end
    return unless input_str.size > 1

    total_lines = lines_point(input_str).sum.to_s.rjust(8)
    total_words = words_point(input_str).sum.to_s.rjust(8)
    total_bytsizes = bytesize_point(input_str).sum.to_s.rjust(8)
    puts "#{total_lines}#{total_words}#{total_bytsizes} total\n"

  else
    puts "wc: #{input_str}: open: No such file or directory"
  end
end

def output_wc_l(input_str)
  if File.exist?(input_str[0])
    input_str.each_with_index do |_, i|
      line = lines_point(input_str)[i].to_s.rjust(8)
      name = file_name(input_str)[i]
      puts "#{line} #{name}"
    end
    return unless input_str.size > 1

    total_lines = lines_point(input_str).sum.to_s.rjust(8)
    puts "#{total_lines} total\n"

  else
    puts "wc: #{input_str}: open: No such file or directory"
  end
end

def lines_point(input_str)
  input_str.map { |a| File.read(a).count("\n") }
end

def words_point(input_str)
  input_str.map { |a| File.read(a).split(/\s+/).size }
end

def bytesize_point(input_str)
  input_str.map { |a| File.read(a).bytesize }
end

def file_name(input_str)
  input_str.map { |a| File.basename(a) }
end

main
