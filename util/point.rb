# frozen_string_literal: true

class Point
  def initialize(x, y)
    @x = x.freeze
    @y = y.freeze
  end

  attr_reader :x, :y

  def +(other)
    Point.new(x + other.x, y + other.y)
  end

  def to_a
    [x, y]
  end
end
