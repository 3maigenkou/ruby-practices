# frozen_string_literal: true

require 'etc'

class OptionL
  def output
    puts "total #{total}"
  end

  # private

  def initialize(files_name)
    @files_name = files_name
    @files_data = files_name.map { |data| File::Stat.new(data) }
  end

  def total
    @files_data.map(&:blocks).sum
  end

  def total_data
    total_data = []
    total_data << files_type
    total_data << file_mode
    total_data << file_permission_owner
    total_data << file_permission_group
    total_data << file_permission_other
    total_data << file_nlink
    total_data << owner_name
    total_data << group_name
    total_data << file_size
    total_data << time_stamp
    total_data << file_name
  end

  def files_type
    files_type = @files_data.map(&:ftype).map(&:to_sym)
    files_type.map { |file| convert_file_type(file) }
  end

  def file_mode
    @files_data.map { |file| format('%o', file.mode) }
  end

  def file_permission_owner
    owner_permission_number = file_mode.map { |mode| mode[-3] }
    owner_permission_number_sym = owner_permission_number.map(&:to_sym)
    owner_permission_number_sym.map { |number| convert_permission(number) }
  end

  def file_permission_group
    group_permission_number = file_mode.map { |mode| mode[-2] }
    group_permission_number_sym = group_permission_number.map(&:to_sym)
    group_permission_number_sym.map { |number| convert_permission(number) }
  end

  def file_permission_other
    other_permission_number = file_mode.map { |mode| mode[-1] }
    other_permission_number_sym = other_permission_number.map(&:to_sym)
    other_permission_number_sym.map { |number| convert_permission(number) }
  end

  def file_nlink
    @files_data.map(&:nlink)
  end

  def owner_name
    @files_data.map { |file| Etc.getpwuid(file.uid).name }
  end

  def group_name
    @files_data.map { |file| Etc.getgrgid(file.gid).name }
  end

  def file_size
    @files_data.map(&:size)
  end

  def time_stamp
    @files_data.map { |file| file.mtime.strftime('%-m  %-d %R') }
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

  def file_name
    @files_name
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
