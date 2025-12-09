# frozen_string_literal: true

# Helpers
Vec2 = Struct.new(:x, :y)

# Data
vecs = File.read("input.txt")
  .split("\n")
  .map { |line| Vec2.new(*line.split(",").map(&:to_i)) }

# Part 1
part_one = vecs.flat_map do |v1|
  vecs.map { |v2| ((v2.x - v1.x).abs + 1) * ((v2.y - v1.y).abs + 1) }
end.max

p part_one
