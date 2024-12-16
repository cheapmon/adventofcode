# frozen_string_literal: true

require "../../util/board"

DELTAS = {
  "^" => [0, -1],
  ">" => [1, 0],
  "v" => [0, 1],
  "<" => [-1, 0],
}.freeze

def move(board, movement)
  x, y = board.find { |x, y| board[x, y] == "@" }
  dx, dy = DELTAS[movement] || return
  search_x, search_y = x, y

  loop do
    search_x += dx
    search_y += dy

    return if board[search_x, search_y] == "#"
    break if board[search_x, search_y] == "."
  end

  board[x, y] = "."
  symbol = "@"

  loop do
    x += dx
    y += dy

    tmp = symbol
    symbol = board[x, y]
    board[x, y] = tmp

    break if symbol == "."
  end
end

map, movements = File.read("15.txt").split("\n\n")

board = Board.read_string(map)
movements = movements.strip.split("")

while (movement = movements.shift)
  move(board, movement)
end

puts board.filter { |x, y| board[x, y] == "O" }.sum(0) { |x, y| y * 100 + x }
