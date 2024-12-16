# frozen_string_literal: true

require_relative "../../util/board"
require_relative "../../util/direction"
require_relative "../../util/point"

def best_path(board)
  cache = Board.new(board.width, board.height) { nil }
  point = Point.new(*board.find { |x, y| board[x, y] == "S" })
  direction = Direction.right

  queue = [[point, direction, 0]]

  while (point, direction, value = queue.shift)
    next if cache[*point] && cache[*point] < value

    cw = direction.rotate(1)
    ccw = direction.rotate(-1)

    cache[*point] = value

    new_point = point + direction.to_point
    if board[*new_point] != "#" && (cache[*new_point].nil? || cache[*new_point] > value + 1)
      queue << [new_point, direction, value + 1]
    end

    new_point = point + cw.to_point
    if board[*new_point] != "#" && (cache[*new_point].nil? || cache[*new_point] > value + 1001)
      queue << [new_point, cw, value + 1001]
    end

    new_point = point + ccw.to_point
    if board[*new_point] != "#" && (cache[*new_point].nil? || cache[*new_point] > value + 1001)
      queue << [point + ccw.to_point, ccw, value + 1001]
    end
  end

  x, y = board.find { |x, y| board[x, y] == "E" }
  cache[x, y]
end

board = Board.read("16.txt").freeze

puts best_path(board)
