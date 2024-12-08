# frozen_string_literal: true

require_relative "../../util/board"

def place_antinodes(board, x1, y1, x2, y2, max_depth: 1)
  antinodes = Set[]
  dx, dy = x2 - x1, y2 - y1

  x, y, depth = x1 - dx, y1 - dy, 0
  while board.in_bounds?(x, y) && depth < max_depth
    antinodes << [x, y]
    x, y, depth = x - dx, y - dy, depth + 1
  end

  x, y, depth = x2 + dx, y2 + dy, 0
  while board.in_bounds?(x, y) && depth < max_depth
    antinodes << [x, y]
    x, y, depth = x + dx, y + dy, depth + 1
  end

  antinodes
end

board = Board.read("8.txt")
frequencies = board.map { |x, y| board[x, y] }.to_set.delete(".")

antinodes_1 = Set[]
antinodes_2 = Set[]

frequencies.each do |frequency|
  pairs = board.filter { |x, y| board[x, y] == frequency }.combination(2)

  pairs.each do |(x1, y1), (x2, y2)|
    antinodes_1 += place_antinodes(board, x1, y1, x2, y2)
    antinodes_2 += place_antinodes(board, x1, y1, x2, y2, max_depth: Float::INFINITY)
  end
end

puts antinodes_1.count

b = board.clone
antinodes_2.each { |x, y| b[x, y] = "#" }
puts b.count { |x, y| b[x, y] != "." }
