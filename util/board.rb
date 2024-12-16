# frozen_string_literal: true

class Board
  include Enumerable

  attr_reader :width, :height

  def initialize(width, height)
    @width = width
    @height = height
    @data = []

    each do |x, y|
      self[x, y] = yield x, y
    end
  end

  def self.read(pathname)
    read_string(File.read(pathname))
  end

  def self.read_string(string)
    lines = string.strip.lines.map(&:strip)

    new(lines.first.size, lines.size) { |x, y| lines[y][x] }
  end

  def [](x, y)
    @data[x + y * width]
  end

  def []=(x, y, value)
    @data[x + y * width] = value
  end

  def in_bounds?(x, y)
    xs.include?(x) && ys.include?(y)
  end

  def each
    ys.each do |y|
      xs.each do |x|
        yield x, y
      end
    end
  end

  def clone
    Board.new(width, height) { |x, y| self[x, y].dup }
  end

  private

  def xs
    0..(width - 1)
  end

  def ys
    0..(height - 1)
  end
end
