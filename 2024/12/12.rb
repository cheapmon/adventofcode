# frozen_string_literal: true

require_relative "../../util/board"

Region = Struct.new(:plant, :coords)

def grow_region(board, start_x, start_y)
  plant = board[start_x, start_y]
  region = Region.new(plant, Set[[start_x, start_y]])

  queue = [[start_x, start_y]]
  done = Set[]

  while (x, y = queue.shift)
    done << [x, y]

    neighbors = [[0, -1], [-1, 0], [1, 0], [0, 1]]
      .map { |dx, dy| [x + dx, y + dy] }
      .filter { |x, y| board.in_bounds?(x, y) && board[x, y] == plant }
      .reject { |x, y| done.include?([x, y]) }

    neighbors.each do |x, y|
      region.coords << [x, y]
      queue << [x, y] unless queue.include?([x, y])
    end
  end

  region
end

def price_of_region_1(board, region)
  perimeter = region.coords.sum(0) do |x, y|
    [[0, -1], [-1, 0], [1, 0], [0, 1]]
      .map { |dx, dy| [x + dx, y + dy] }
      .count { |x, y| !region.coords.include?([x, y]) }
  end

  region.coords.count * perimeter
end

def price_of_region_2(board, region)
  corners = Set[]

  region.coords.each do |x, y|
    is_in_region = ->(x, y) { region.coords.include?([x, y]) }

    top = is_in_region.call(x, y - 1)
    top_left = is_in_region.call(x - 1, y - 1)
    top_right = is_in_region.call(x + 1, y - 1)
    left = is_in_region.call(x - 1, y)
    right = is_in_region.call(x + 1, y)
    bottom = is_in_region.call(x, y + 1)
    bottom_left = is_in_region.call(x - 1, y + 1)
    bottom_right = is_in_region.call(x + 1, y + 1)

    corners << [x, y] unless (top && !left && !top_left) || (!top && left && !top_left) || (top && left && top_left)
    corners << [x + 1, y] unless (top && !right && !top_right) || (!top && right && !top_right) || (top && right && top_right)
    corners << [x + 1, y + 1] unless (bottom && !right && !bottom_right) || (!bottom && right && !bottom_right) || (bottom && right && bottom_right)
    corners << [x, y + 1] unless (bottom && !left && !bottom_left) || (!bottom && left && !bottom_left) || (bottom && left && bottom_left)
  end

  region.coords.count * corners.count
end

board = Board.read("12.txt").freeze
regions = []

board.each do |x, y|
  unless regions.any? { |region| region.coords.include?([x, y]) }
    regions << grow_region(board, x, y)
  end
end

puts regions.sum(0) { |region| price_of_region_1(board, region) }
puts regions.sum(0) { |region| price_of_region_2(board, region) }
