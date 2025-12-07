# frozen_string_literal: true

class Grid
  attr_reader :width, :height

  def self.from_string(string)
    data = string.split("\n").map { it.split("") }

    width = data.first.length
    height = data.length

    new(width, height) { |x, y| data[y][x] }
  end

  def initialize(width, height)
    @width = width
    @height = height
    @data = Array.new(width * height) do |index|
      x = index % width
      y = index / width

      yield x, y
    end
  end

  def xs
    0.upto(width - 1)
  end

  def ys
    0.upto(height - 1)
  end

  def [](x, y)
    @data[width * y + x]
  end

  def []=(x, y, value)
    @data[width * y + x] = value
  end

  include Enumerable

  def each
    ys.each do |y|
      xs.each do |x|
        yield x, y
      end
    end
  end
end

# Data
input = File.read("input.txt")

# Part 1
grid = Grid.from_string(input)
x, y = grid.find { |x, y| grid[x, y] == "S" }
xs = [x]
y += 1
part_one = 0

while y < grid.height
  xs = xs.flat_map do |x|
    if grid[x, y] == "^"
      part_one += 1

      grid[x-1, y] = "|"
      grid[x+1, y] = "|"

      [x-1, x+1]
    else
      grid[x, y] = "|"

      [x]
    end
  end.uniq

  y += 1
end

p part_one

# Part 2
grid = Grid.from_string(input)
x, y = grid.find { |x, y| grid[x, y] == "S" }
y += 1

part_two = Grid.new(grid.width, grid.height) { 0 }
part_two[x, y] = 1

while y < grid.height
  grid.xs.each do |x|
    if grid[x, y] == "^"
      grid[x - 1, y] = "|"
      grid[x + 1, y] = "|"

      part_two[x - 1, y] += part_two[x, y - 1]
      part_two[x + 1, y] += part_two[x, y - 1]
    end

    if grid[x, y - 1] == "|" && %w[. |].include?(grid[x, y])
      grid[x, y] = "|"

      part_two[x, y] += part_two[x, y - 1]
    end
  end

  y += 1
end

part_two = part_two.xs.sum { |x| part_two[x, y-1] }
p part_two
