# frozen_string_literal: true

require "matrix"

def digit?(str)
  %w[0 1 2 3 4 5 6 7 8 9].include?(str)
end

def symbol?(str)
  !digit?(str) && str != "."
end

def part_number(row, col)
  str = @matrix[row, col]

  dcol = 1
  while (digit?(@matrix[row, col + dcol])) do
    str += @matrix[row, col + dcol]
    dcol += 1
  end

  str.to_i
end

@matrix = Matrix.rows(File.read("3.txt").split("\n").map { |line| line.split("") })
@part_coords = []
@gear_ratio_sum = 0

@matrix.each_with_index do |e, row, col|
  next unless symbol?(e)

  coords = []

  [-1, 0, 1].repeated_permutation(2) do |drow, dcol|
    e = @matrix[row + drow, col + dcol]

    next unless digit?(e)

    ddcol = 0
    ddcol -= 1 while digit?(@matrix[row + drow, col + dcol + ddcol])
    coords << [row + drow, col + dcol + ddcol + 1]
  end

  @part_coords += coords

  next unless @matrix[row, col] == "*" && coords.uniq.count == 2

  part_numbers = coords.uniq.map { |row, col| part_number(row, col) }
  @gear_ratio_sum += part_numbers.inject(:*)
end

p @part_coords.uniq.map { |row, col| part_number(row, col) }.sum(0)
p @gear_ratio_sum
