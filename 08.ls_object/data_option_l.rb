# frozen_string_literal: true

require 'etc'

class DataOptionL
  def initialize(file_name)
    @file_name = file_name
    @file_data = File::Stat.new(file_name)
  end

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
      file_name,
    ]
  end

  def file_blocks
    @file_data.blocks
  end

  private

  def file_type
    file_type = @file_data.ftype.to_sym
    convert_file_type(file_type)
  end

  def file_mode
    format('%o', @file_data.mode)
  end

  def file_permission_owner
    owner_permission_number = file_mode[-3].to_sym
    convert_permission(owner_permission_number)
  end

  def file_permission_group
    group_permission_number = file_mode[-2].to_sym
    convert_permission(group_permission_number)
  end

  def file_permission_other
    other_permission_number = file_mode[-1].to_sym
    convert_permission(other_permission_number)
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
    @file_data.mtime.strftime('%-m').rjust(3) + @file_data.mtime.strftime('%-d').rjust(3) + @file_data.mtime.strftime('%R').rjust(6)
  end

  def file_name
    "\s#{@file_name}"
  end

  def convert_file_type(file_type)
    {
      fifo: 'p',
      characterSpecial: 'c',
      directory: 'd',
      blockSpecial: 'b',
      file: '-',
      link: 'l',
      socket: 's'
    }[file_type]
  end

  def convert_permission(file_permission)
    {
      "0": '---',
      "1": '--x',
      "2": '-w-',
      "3": '-wx',
      "4": 'r--',
      "5": 'r-x',
      "6": 'rw-',
      "7": 'rwx'
    }[file_permission]
  end
end
