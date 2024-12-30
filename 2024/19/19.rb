# frozen_string_literal: true

def part_one(rest, patterns, cache = {})
  return true if rest.empty?
  return cache[rest] if cache.key?(rest)

  cache[rest] = patterns.any? do |pattern|
    rest.start_with?(pattern) && part_one(rest.sub(pattern, ""), patterns, cache)
  end
end

def part_two(rest, patterns, cache = {})
  return 1 if rest.empty?
  return cache[rest] if cache.key?(rest)

  cache[rest] = patterns.sum(0) do |pattern|
    if rest.start_with?(pattern)
      part_two(rest.sub(pattern, ""), patterns, cache)
    else
      0
    end
  end
end

patterns, *designs = File.read("19.txt").lines.map(&:strip).reject(&:empty?)
patterns = patterns.split(", ")

puts designs.count { |design| part_one(design, patterns) }
puts designs.sum(0) { |design| part_two(design, patterns) }
