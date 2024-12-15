# frozen_string_literal: true

Robot = Struct.new(:x, :y, :dx, :dy) do
  def tick(width, height)
    self.x = (x + dx) % width
    self.y = (y + dy) % height
  end
end

initial_robots = File.read("14.txt")
  .lines
  .map { |line| Robot.new(*line.scan(/-?\d+/).map(&:to_i)) }
robots = initial_robots.dup

width = 101 # 11
height = 103 # 7

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
