# frozen_string_literal: true

class Direction
  VALUES = { up: 0, right: 1, down: 2, left: 3 }.freeze
  DELTAS = { up: [0, -1], right: [1, 0], down: [0, 1], left: [-1, 0] }.freeze

  private_constant :VALUES, :DELTAS

  class << self
    def up; new(VALUES[:up]); end
    def right; new(VALUES[:right]); end
    def down; new(VALUES[:down]); end
    def left; new(VALUES[:left]); end
  end

  def initialize(value)
    @value = value.freeze
    @name = VALUES.key(value).freeze
  end

  attr_reader :name

  def rotate(amount = 1)
    Direction.new((value + amount) % 4)
  end

  def to_point
    Point.new(*DELTAS[name])
  end

  private

  attr_reader :value
end
