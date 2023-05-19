# frozen_string_literal: true

require 'etc'

CONVERT_FILE_TYPE = {
  fifo: 'p',
  characterSpecial: 'c',
  directory: 'd',
  blockSpecial: 'b',
  file: '-',
  link: 'l',
  socket: 's'
}.freeze

CONVERT_PERMISSION = {
  "0": '---',
  "1": '--x',
  "2": '-w-',
  "3": '-wx',
  "4": 'r--',
  "5": 'r-x',
  "6": 'rw-',
  "7": 'rwx'
}.freeze

class DataOptionL
  def initialize(file_name)
    @file_name = file_name
    @file_data = File::Stat.new(file_name)
  end

  def long_option_output
    total_data.join
  end

  def file_blocks
    @file_data.blocks
  end

  private

  def total_data
    [
      file_type,
      file_permission_owner,
      file_permission_group,
      file_permission_other,
      file_nlink,
      owner_name,
      group_name,
      file_size,
      time_stamp,
      file_name
    ]
  end

  def file_type
    CONVERT_FILE_TYPE[@file_data.ftype.to_sym]
  end

  def file_mode
    format('%o', @file_data.mode)
  end

  def file_permission_owner
    CONVERT_PERMISSION[file_mode[-3].to_sym]
  end

  def file_permission_group
    CONVERT_PERMISSION[file_mode[-2].to_sym]
  end

  def file_permission_other
    CONVERT_PERMISSION[file_mode[-1].to_sym]
  end

  def file_nlink
    @file_data.nlink.to_s.rjust(3)
  end

  def owner_name
    Etc.getpwuid(@file_data.uid).name.to_s.rjust(9)
  end

  def group_name
    Etc.getgrgid(@file_data.gid).name.to_s.rjust(7)
  end

  def file_size
    @file_data.size.to_s.rjust(6)
  end

  def time_stamp
    @file_data.mtime.strftime('  %-m %-d %R')
  end

  def file_name
    "\s#{@file_name}"
  end
end
