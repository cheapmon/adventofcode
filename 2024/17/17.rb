# frozen_string_literal: true

def run(a, b, c, instructions)
  i = 0
  out = []

  while i < instructions.length
    opcode, operand = instructions[i, 2]

    combo_operand = case operand
      when 0..3
        operand
      when 4
        a
      when 5
        b
      when 6
        c
      end

    case opcode
    when 0
      a = (a.to_f / 2 ** combo_operand).to_i
      i += 2
    when 1
      b ^= operand
      i += 2
    when 2
      b = combo_operand % 8
      i += 2
    when 3
      i = (a != 0) ? operand : (i + 2)
    when 4
      b ^= c
      i += 2
    when 5
      out << (combo_operand % 8)
      i += 2
    when 6
      b = (a.to_f / 2 ** combo_operand).to_i
      i += 2
    when 7
      c = (a.to_f / 2 ** combo_operand).to_i
      i += 2
    end
  end

  out
end

def recurse(a, b, c, instructions)
  8.times do |rest|
    next_a = a * 8 + rest
    out = run(next_a, b, c, instructions)

    next if instructions.last(out.length) != out
    return next_a if out.length == instructions.length
    recurse(next_a, b, c, instructions)&.tap { |r| return r }
  end

  nil
end

text = File.read("17.txt")
a, b, c, *instructions = text.scan(/\d+/).map(&:to_i)

puts run(a, b, c, instructions).join(",")
puts recurse(0, b, c, instructions)
