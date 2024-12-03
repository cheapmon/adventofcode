# frozen_string_literal: true

lines = File.read("3.txt")

puts lines.scan(/mul\((\d{1,3}),(\d{1,3})\)/)
       .map { |a, b| a.to_i * b.to_i }
       .sum(0)

mul = true
sum = 0

lines.scan(/mul\((\d{1,3}),(\d{1,3})\)|(do\(\))|(don't\(\))/)
  .each do |match|
  sum += match[0].to_i * match[1].to_i if mul

  mul = true if match.include?("do()")
  mul = false if match.include?("don't()")
end

puts sum
