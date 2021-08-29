#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l')
  file_name = ARGV.empty? ? $stdin.readlines.map(&:chomp) : ARGV
  options['l'] ? output_wc_l(file_name) : output_wc(file_name)
end

def output_wc(file_name)
  if File.exist?(file_name[0])
    file_name.each do |a|
      file = File.read(a)
      file_lines = file.count("\n").to_s.rjust(8)
      words = file.split(/\s+/).size.to_s.rjust(7)
      bytesize = file.bytesize.to_s.rjust(7)
      name = File.basename(a)
      puts "#{file_lines} #{words} #{bytesize} #{name}"
    end
    return unless file_name.size > 1

    total_lines_point(file_name)
    total_words_point(file_name)
    total_bytesize_point(file_name)
    print " total\n"

  else
    total_lines_point_nofile(file_name)
    total_words_point_nofile(file_name)
    total_bytesize_point_nofile(file_name)
    print "\n"
  end
end

def output_wc_l(file_name)
  if File.exist?(file_name[0])
    file_name.each do |a|
      file = File.read(a)
      file_lines = file.count("\n").to_s.rjust(8)
      name = File.basename(a)
      puts "#{file_lines} #{name}"
    end
    return unless file_name.size > 1

    total_lines_point(file_name)
    print " total\n"

  else
    total_lines_point_nofile(file_name)
    print "\n"
  end
end

def total_lines_point(file_name)
  total_file_lines = []
  file_name.each do |a|
    file = File.read(a)
    total_file_lines << file.count("\n")
  end
  print total_file_lines.inject(:+).to_s.rjust(8)
end

def total_words_point(file_name)
  total_file_words = []
  file_name.each do |a|
    file = File.read(a)
    words = file.split(/\s+/)
    total_file_words << words.size
  end
  print total_file_words.inject(:+).to_s.rjust(8)
end

def total_bytesize_point(file_name)
  total_file_bytesize = []
  file_name.each do |a|
    file = File.read(a)
    total_file_bytesize << file.bytesize
  end
  print total_file_bytesize.inject(:+).to_s.rjust(8)
end

def total_lines_point_nofile(file_name)
  print file_name.size.to_s.rjust(8)
end

def total_words_point_nofile(file_name)
  total_words = []
  file_name.each_with_index do |_a, i|
    total_words << file_name[i].split(/\s+/).size
  end
  print total_words.inject(:+).to_s.rjust(8)
end

def total_bytesize_point_nofile(file_name)
  total_bytesize = []
  file_name.each_with_index do |_a, i|
    total_bytesize << file_name[i].bytesize
  end
  print total_bytesize.inject(:+).to_s.rjust(8)
end

main
