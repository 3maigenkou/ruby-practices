# frozen_string_literal: true

class OptionL
  def initialize(files_name)
    @files_data = files_name.map { |data| File::Stat.new(data) }
  end

  def output
    p file_type1
  end

  def total
    @files_data.map(&:blocks).sum
  end

  def file_type
    @files_data.map(&:ftype).map(&:to_sym)
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
