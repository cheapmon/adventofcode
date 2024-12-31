# frozen_string_literal: true

require_relative "../../util/board"

Robot = Struct.new(:x, :y, :dx, :dy) do
  def tick(width, height)
    self.x = (x + dx) % width
    self.y = (y + dy) % height
  end
end

initial_robots = File.read("14.txt")
  .lines
  .map { |line| Robot.new(*line.scan(/-?\d+/).map(&:to_i)) }
  .freeze
robots = initial_robots.map(&:clone)

width = demo? ? 11 : 101
height = demo? ? 7 : 103

100.times do
  robots.each { |robot| robot.tick(width, height) }
end

mid_x = width / 2
mid_y = height / 2

a = robots.count { |robot| robot.x < mid_x && robot.y < mid_y }
b = robots.count { |robot| robot.x < mid_x && robot.y > mid_y }
c = robots.count { |robot| robot.x > mid_x && robot.y < mid_y }
d = robots.count { |robot| robot.x > mid_x && robot.y > mid_y }

puts a * b * c * d

robots = initial_robots.map(&:clone)
found = nil

(1..).each do |i|
  robots.each { |robot| robot.tick(width, height) }

  board = Board.new(width, height) { 0 }
  robots.each { |robot| board[robot.x, robot.y] += 1 }

  board.each do |x, y|
    deltas = [[0, 0], [1, 0], [2, 0], [0, 1], [1, 1], [2, 1], [0, 2], [1, 2], [2, 2]]

    if deltas.all? { |dx, dy| board.in_bounds?(x + dx, y + dy) && board[x + dx, y + dy] == 1 }
      found = i
      break
    end
  end

  break if found
end

puts found
