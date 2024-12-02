# frozen_string_literal: true

left = []
right = []

File.foreach("1.txt", chomp: true).each do |line|
  a, b = line.split("   ").map(&:to_i)

  left << a
  right << b
end

left.sort!
right.sort!

puts left.zip(right).map { |a, b| (a - b).abs }.sum
puts left.map { |a| a * right.count(a) }.sum
