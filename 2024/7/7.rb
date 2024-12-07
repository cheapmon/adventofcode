# frozen_string_literal: true

def part_one(numbers, target, current = 0)
  return target == current if numbers.empty?

  n = numbers.shift
  [current * n, current + n].any? do |c|
    part_one(numbers.dup, target, c)
  end
end

def part_two(numbers, target, current = 0)
  return target == current if numbers.empty?

  n = numbers.shift
  [current * n, current + n, (current.to_s + n.to_s).to_i].any? do |c|
    part_two(numbers.dup, target, c)
  end
end

lines = File.read("7.txt").lines.map { |line| line.strip.split(/:? /).map(&:to_i) }

puts lines.filter_map { |result, *numbers| result if part_one(numbers, result) }.sum(0)
puts lines.filter_map { |result, *numbers| result if part_two(numbers, result) }.sum(0)
