# frozen_string_literal: true

require_relative "../../util/board"

DIRECTIONS = %i[up right down left].freeze

def patrol(board)
  x, y = board.find { |x, y| board[x, y] == "^" }
  direction = 0

  positions = Set[]
  positions_with_direction = Set[]

  while x.between?(0, board.width - 1) && y.between?(0, board.height - 1)
    return false if positions_with_direction.include?([x, y, direction])

    next_x, next_y = case DIRECTIONS[direction]
      when :up
        [x, y - 1]
      when :right
        [x + 1, y]
      when :down
        [x, y + 1]
      when :left
        [x - 1, y]
      end

    if board[next_x, next_y] == "#"
      direction = (direction + 1) % 4
    else
      positions << [x, y]
      positions_with_direction << [x, y, direction]
      x, y = next_x, next_y
    end
  end

  positions.count
end

board = Board.read("6.txt")

puts patrol(board)

obstructions = board.count do |x, y|
  next if %w[^ #].include?(board[x, y])

  new_board = board.clone
  new_board[x, y] = "#"

  patrol(new_board) == false
end

puts obstructions
