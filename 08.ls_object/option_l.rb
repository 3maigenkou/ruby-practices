# frozen_string_literal: true

require_relative 'data_option_l'

class OptionL
  def initialize(files_name)
    @files_data = files_name.map { |file| DataOptionL.new(file).total_data }
    @blocks_sum = files_name.map { |file| DataOptionL.new(file).file_blocks }.sum
  end

  def output
    puts "total #{@blocks_sum}"
    @files_data.each do |data|
      puts data[0..9].join
    end
  end

end
