# frozen_string_literal: true

require_relative 'data_option_l'

class OptionL
  def initialize(files_name)
    @files_data = files_name.map { |file| DataOptionL.new(file) }
  end

  def output
    puts "total #{blocks_sum}"
    @files_data.each do |file|
      puts file.long_option_output.to_s
    end
  end

  private

  def blocks_sum
    @files_data.map(&:file_blocks).sum
  end
end
