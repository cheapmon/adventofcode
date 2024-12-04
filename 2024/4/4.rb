# frozen_string_literal: true

class Board
  attr_reader :width, :height

  def initialize(width, height, &block)
    @width = width
    @height = height
    @data = []

    xs.each do |x|
      ys.each do |y|
        self[x, y] = yield x, y
      end
    end
  end

  def [](x, y)
    @data[x + y * width]
  end

  def []=(x, y, value)
    @data[x + y * width] = value
  end

  def xs
    0..(width - 1)
  end

  def ys
    0..(height - 1)
  end
end

data = File.read("4.txt").lines.map { |line| line.strip.split("") }
board = Board.new(data.first.size, data.size) { |x, y| data[y][x] }

count_xmas = 0
count_mas = 0

board.xs.each do |x|
  board.ys.each do |y|
    # XMAS horizontal
    if x <= board.width - 4
      word = board[x, y] + board[x + 1, y] + board[x + 2, y] + board[x + 3, y]
      count_xmas += 1 if (word == "XMAS" || word == "SAMX")
    end

    # XMAS vertical
    if y <= board.height - 4
      word = board[x, y] + board[x, y + 1] + board[x, y + 2] + board[x, y + 3]
      count_xmas += 1 if (word == "XMAS" || word == "SAMX")
    end

    # XMAS diagonal
    if x <= board.width - 4 && y <= board.height - 4
      word = board[x, y] + board[x + 1, y + 1] + board[x + 2, y + 2] + board[x + 3, y + 3]
      count_xmas += 1 if word == "XMAS" || word == "SAMX"
    end

    if x >= 3 && y <= board.height - 4
      word = board[x, y] + board[x - 1, y + 1] + board[x - 2, y + 2] + board[x - 3, y + 3]
      count_xmas += 1 if (word == "XMAS" || word == "SAMX")
    end

    # X-MAS
    if x >= 1 && x <= board.width - 2 && y >= 1 && y <= board.height - 2
      a = board[x - 1, y - 1] + board[x, y] + board[x + 1, y + 1]
      b = board[x + 1, y - 1] + board[x, y] + board[x - 1, y + 1]

      count_mas += 1 if %w[MAS SAM].include?(a) && %w[MAS SAM].include?(b)
    end
  end
end

puts count_xmas
puts count_mas
