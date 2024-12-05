# frozen_string_literal: true

def update_in_order?(update, rules)
  rules.each do |a, b|
    index_a = update.index(a)
    index_b = update.index(b)

    next if index_a.nil? || index_b.nil?
    return false if index_a > index_b
  end

  true
end

def sort_update(update, rules)
  update.sort do |a, b|
    if rules.include?([a, b])
      -1
    elsif rules.include?([b, a])
      1
    else
      0
    end
  end
end

text = File.read("5.txt")
rules, updates = text.split("\n\n")

rules = rules.lines.map { |line| line.strip.split("|") }
updates = updates.lines.map { |line| line.strip.split(",") }

puts updates.filter { |update| update_in_order?(update, rules) }
    .map { |update| update[update.size / 2].to_i }
    .sum(0)

puts updates.reject { |update| update_in_order?(update, rules) }
    .map { |update| sort_update(update, rules) }
    .map { |update| update[update.size / 2].to_i }
    .sum(0)
