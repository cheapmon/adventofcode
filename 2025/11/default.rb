# frozen_string_literal: true

# Helpers
def parse_node(line)
  node, *children = line.split(/:? +/)

  [node, children]
end

# Part 1
def part_one(graph)
  paths = graph.keys.append(*graph.values.flatten).uniq.to_h { |u| [u, 0] }.merge("you" => 1)
  queue = %w[you]
  visited = []

  while (u = queue.shift)
    visited << u
    graph[u]&.each do |v|
      paths[v] += paths[u]
      queue << v if !visited.include?(v) && !queue.include?(v)
    end
  end

  paths["out"]
end

lines = File.read("input.txt").split("\n")
graph = lines.to_h { |line| parse_node(line) }
puts part_one(graph)

# Part 2
def part_two(graph)
  paths = graph.keys.append(*graph.values.flatten).uniq.to_h { |u| [u, 0] }
  queue = %w[svr]
  visited = []

  while (u = queue.shift)
    visited << u
    graph[u]&.each do |v|
      # inc = %w[dac fft].include?(u) ? 1 : 0
      # paths[v] = [paths[u] + inc, paths[v]].max
      paths[v] += paths[u]
      paths[v] += 1 if %w[dac fft].include?(u)

      queue << v if !visited.include?(v) && !queue.include?(v)
    end
  end

  pp paths
  paths["out"]
end

lines = File.read("input.txt").split("\n")
graph = lines.to_h { |line| parse_node(line) }
puts part_two(graph)
