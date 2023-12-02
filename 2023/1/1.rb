# frozen_string_literal: true

@terms = %w[zero one two three four five six seven eight nine]
@lines = File.read("1.txt").split("\n")

def value(line, terms = false)
  digits = []

  line.split("").each_with_index do |_, index|
    @terms.each do |term|
      if line[index..].start_with?(term) && terms
        digits << @terms.index(term)
      end
    end

    if %w[1 2 3 4 5 6 7 8 9].include?(line[index])
      digits << line[index].to_i
    end
  end

  [digits[0], digits[-1]].join.to_i
end

p @lines.map { |line| value(line) }.sum(0)
p @lines.map { |line| value(line, true) }.sum(0)
