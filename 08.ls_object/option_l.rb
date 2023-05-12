# frozen_string_literal: true

require_relative 'data_option_l'

class OptionL
  def initialize(files_name)
    @files_data = files_name.map { |file| DataOptionL.new(file) }
  end

  def output
    puts "total #{blocks_sum}"
    total_data.each do |data|
      puts data[0..9].join
    end
  end

  private

  def total_data
    @files_data.map(&:total_data)
  end

  def blocks_sum
    @files_data.map(&:file_blocks).sum
  end
end
