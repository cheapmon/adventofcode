# frozen_string_literal: true

require "matrix"
require_relative "../../util/array"

def solve(ax, ay, bx, by, px, py)
  x = Vector[ax, bx, px]
  y = Vector[ay, by, py]

  x *= ax.lcm(ay) / ax
  y *= ax.lcm(ay) / ay

  diff = x - y
  b = diff[2].to_f / diff[1]
  a = (px - (bx * b)) / ax

  [a, b] if (a % 1).zero? && (b % 1).zero?
end

def minimum_tokens(configs)
  configs.sum(0) do |ax, ay, bx, by, px, py|
    a, b = solve(ax, ay, bx, by, px, py)

    3 * a.to_i + b.to_i
  end
end

text = File.read("13.txt")
configs = text.lines.map(&:strip).split(&:empty?).map do |lines|
  ax, ay = lines[0].scan(/\d+/).map(&:to_i)
  bx, by = lines[1].scan(/\d+/).map(&:to_i)
  px, py = lines[2].scan(/\d+/).map(&:to_i)

  [ax, ay, bx, by, px, py]
end

puts minimum_tokens(configs)

configs = configs.map { |*rest, px, py| [*rest, px + 10_000_000_000_000, py + 10_000_000_000_000] }
puts minimum_tokens(configs)
