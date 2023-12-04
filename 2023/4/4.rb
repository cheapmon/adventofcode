# frozen_string_literal: true

def parse(line)
  line
    .sub(/^Card\s+\d+:\s+/, "")
    .strip
    .split(" | ")
    .map { |n| n.strip.split(/\s+/).map(&:to_i) }
end

def part_one(line)
  winning_numbers, numbers = parse(line)

  n = (winning_numbers & numbers).count - 1
  n >= 0 ? 2**n : 0
end

@copies = []
def part_two(line, index)
  winning_numbers, numbers = parse(line)
  @copies[index] ||= 1

  n = (winning_numbers & numbers).count
  @copies[index].times do
    (1..n).each do |i|
      @copies[index + i] = (@copies[index + i] || 1) + 1
    end
  end

  @copies[index]
end

@lines = File.read("4.txt").split("\n")
p @lines.map { |line| part_one(line) }.sum(0)
p @lines.each_with_index.map { |line, index| part_two(line, index) }.sum(0)
