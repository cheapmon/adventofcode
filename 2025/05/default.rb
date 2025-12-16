# frozen_string_literal: true

class IdRange
  attr_reader :lo, :hi

  def self.from_str(str)
    lo, hi = str.split("-").map(&:to_i)
    new(lo, hi)
  end

  def initialize(lo, hi)
    @lo = lo
    @hi = hi
  end

  def overlaps?(other)
    lo <= other.hi && other.lo <= hi
  end

  def combine(other)
    IdRange.new([lo, other.lo].min, [hi, other.hi].max) if overlaps?(other)
  end

  def count
    hi - lo + 1
  end
end

blocks = File.read("input.txt").split("\n\n")
ranges = blocks[0].split("\n").map { |line| IdRange.from_str(line) }.sort_by(&:lo)

merged = ranges.each_with_object([]) do |range, acc|
  if acc.empty? || !acc.last.overlaps?(range)
    acc << range
  else
    acc[-1] = acc.last.combine(range)
  end
end

p merged.sum(&:count)
