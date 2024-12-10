# frozen_string_literal: true

require_relative "../../util/board"

C = Struct.new(:x, :y)

def trail(board, x, y)
  return C.new(x, y) if board[x, y] == 9

  [[0, -1], [-1, 0], [1, 0], [0, 1]]
    .map { |dx, dy| [x + dx, y + dy] }
    .filter { |x2, y2| board.in_bounds?(x2, y2) && board[x2, y2] - board[x, y] == 1 }
    .flat_map { |x2, y2| trail(board, x2, y2) }
end

board = Board.read("10.txt")
board.each { |x, y| board[x, y] = board[x, y].to_i }

trailheads = board.filter { |x, y| board[x, y] == 0 }

puts trailheads.sum(0) { |x, y| trail(board, x, y).uniq.count }
puts trailheads.sum(0) { |x, y| trail(board, x, y).count }
