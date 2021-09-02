#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

DISPLAY_NUMBER = 3

def main
  options = ARGV.getopts('a', 'r', 'l')
  files = options['a'] ? Dir.entries('.').sort : Dir.glob('*').sort
  files = files.reverse if options['r']
  options['l'] ? output_ls_l(files) : output_ls(files)
end

def output_ls(files)
  files << nil while (files.size % DISPLAY_NUMBER).positive?
  files_ljust = files.map { |a| a.to_s.ljust(20) }
  file_names = files_ljust.each_slice(files.size / DISPLAY_NUMBER).to_a.transpose
  file_names.each do |row|
    puts row.join
  end
end

def output_ls_l(files)
  @blocks = files.map { |a| File::Stat.new(a).blocks }
  puts "total #{@blocks.sum}"
  files.each do |a|
    fs = File::Stat.new(a)
    file_type = File.ftype(a)
    file_permission = format('%o', fs.mode)
    owner = permission_output(file_permission[-3])
    group = permission_output(file_permission[-2])
    other = permission_output(file_permission[-1])
    file_nlink = fs.nlink.to_s.rjust(3)
    owner_name = Etc.getpwuid(fs.uid).name.to_s.rjust(9)
    group_name = Etc.getgrgid(fs.gid).name.to_s.rjust(7)
    file_size = fs.size.to_s.rjust(6)
    time_stamp = fs.mtime.strftime('%-m  %-d %R').rjust(12)
    file_name = File.basename(a).rjust(6)
    puts "#{file_type_output(file_type)}#{owner}#{group}#{other}#{file_nlink}#{owner_name}#{group_name}#{file_size}#{time_stamp}#{file_name}"
  end
end

def file_type_output(file_type)
  {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }[file_type]
end

def permission_output(file_permission)
  {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }[file_permission]
end

main
