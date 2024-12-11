# frozen_string_literal: true

def blink(stone, steps, cache)
  return cache[[stone, steps]] if cache.key?([stone, steps])

  value = if steps.zero?
      1
    elsif stone.zero?
      blink(1, steps - 1, cache)
    elsif Math.log10(stone).floor.odd?
      half = (Math.log10(stone).floor + 1) / 2

      a = stone / (10 ** half)
      b = stone - (a * 10 ** half)

      blink(a, steps - 1, cache) + blink(b, steps - 1, cache)
    else
      blink(stone * 2024, steps - 1, cache)
    end

  cache[[stone, steps]] = value
  value
end

def blink_all(stones, steps, cache)
  stones.sum(0) { |stone| blink(stone, steps, cache) }
end

stones = File.read("11.txt").split(" ").map(&:to_i)
cache = {}

puts blink_all(stones, 25, cache)
puts blink_all(stones, 75, cache)
