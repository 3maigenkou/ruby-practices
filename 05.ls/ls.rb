#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
def main
  options = ARGV.getopts('a', 'r', 'l')
  files = options['a'] ? Dir.entries('.').sort : Dir.glob('*').sort
  files = files.reverse if options['r']
  options['l'] ? output_ls_l(files) : output_ls_ar(files)
end

def output_ls_ar(files)
  files << nil while (files.size % 3).positive?
  files_ljust = []
  files.each do |a|
    files_ljust << a.to_s.ljust(20, ' ')
  end
  file_names = files_ljust.each_slice(files.size / 3).to_a.transpose
  file_names.each do |row|
    puts row.join
  end
end

def output_ls_l(files)
  @blocks = []
  files.each do |a|
    fs = File::Stat.new(a)
    @blocks << fs.blocks
  end
  puts "total #{@blocks.inject(:+)}"
  files.each do |a|
    fs = File::Stat.new(a)
    file_type = File.ftype(a)
    file_permission = format('%o', fs.mode)
    owner = permission_output(file_permission[-3])
    group = permission_output(file_permission[-2])
    other = permission_output(file_permission[-1])
    file_nlink = fs.nlink
    owner_name = Etc.getpwuid(fs.uid).name
    group_name = Etc.getgrgid(fs.gid).name
    file_size = fs.size.to_s.rjust(5)
    time_stamp = fs.mtime.strftime('%-m %d %R')
    file_name = File.basename(a)
    puts "#{file_type_output(file_type)}#{owner}#{group}#{other}  #{file_nlink} #{owner_name}  #{group_name} #{file_size} #{time_stamp} #{file_name}"
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
