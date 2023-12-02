# frozen_string_literal: true

def parse(line)
  _, line = line.split(":")
  entries = line.strip.split(";").flat_map { |str| str.split(",").map(&:strip) }
  entries = entries.map { |entry| entry.split(" ") }.map { |n, c| [n.to_i, c] }

  red = entries.filter { |n, c| c == "red" }.map(&:first).max
  green = entries.filter { |n, c| c == "green" }.map(&:first).max
  blue = entries.filter { |n, c| c == "blue" }.map(&:first).max

  [red, green, blue]
end

def check(line, index)
  red, green, blue = parse(line)

  index + 1 if red <= 12 && green <= 13 && blue <= 14
end

def power(line)
  red, green, blue = parse(line)

  red * green * blue
end

@lines = File.read("2.txt").split("\n")
p @lines.each_with_index.filter_map { |line, index| check(line, index) }.sum(0)
p @lines.map { |line| power(line) }.sum(0)
