# frozen_string_literal: true

text = File.read("9.txt").strip

base_layout = text.split("").each_slice(2).with_index.flat_map do |(file, free_space), index|
  [index] * file.to_i + [nil] * free_space.to_i
end

layout = base_layout.dup
left = 0
right = layout.size - 1

loop do
  right -= 1 while layout[right].nil?
  left += 1 until layout[left].nil?

  break if left >= right

  layout[left] = layout[right]
  layout[right] = nil
end

puts layout.compact.each_with_index.sum(0) { |id, index| id * index }

layout = base_layout.dup

layout.compact.max.downto(0).each do |id|
  right = layout.index(id)
  block_size = layout.rindex(id) - right + 1
  left = layout.each_index.find { |i| i < right && layout[i, block_size].compact.empty? }

  next unless left

  block_size.times do |d|
    layout[left + d] = id
    layout[right + d] = nil
  end
end

puts layout.each_with_index.sum(0) { |id, index| id.to_i * index }
