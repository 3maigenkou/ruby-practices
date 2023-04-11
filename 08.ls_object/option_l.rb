# frozen_string_literal: true

require 'etc'

class OptionL
  def output
    puts "total #{total}"
    total_data.each do |data|
      puts data[0..9].join
    end
  end

  private

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
    total_data << file_permission_owner
    total_data << file_permission_group
    total_data << file_permission_other
    total_data << file_nlink
    total_data << owner_name
    total_data << group_name
    total_data << file_size
    total_data << time_stamp
    total_data << file_name
    total_data.transpose
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
    @files_data.map(&:nlink).map { |data| data.to_s.rjust(3) }
  end

  def owner_name
    @files_data.map { |file| Etc.getpwuid(file.uid).name.to_s.rjust(9) }
  end

  def group_name
    @files_data.map { |file| Etc.getgrgid(file.gid).name.to_s.rjust(8) }
  end

  def file_size
    @files_data.map(&:size).map { |data| data.to_s.rjust(6) }
  end

  def time_stamp
    @files_data.map do |file|
      [file.mtime.strftime('%-m').rjust(3), file.mtime.strftime('%-d').rjust(3), file.mtime.strftime('%R').rjust(6)]
    end
  end

  def file_name
    @files_name.map { |name| " #{name}" }
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
