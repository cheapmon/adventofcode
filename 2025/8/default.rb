# frozen_string_literal: true

Vec3 = Struct.new(:x, :y, :z) do
  def distance(other)
    Math.sqrt(((x - other.x) ** 2) + ((y - other.y) ** 2) + ((z - other.z) ** 2))
  end
end

def step(v1, v2, junction_map)
  @next_id ||= 0

  if junction_map.key?(v1) && junction_map.key?(v2)
    old_id = junction_map[v2]
    new_id = junction_map[v1]

    junction_map.transform_values! { |v| v == old_id ? new_id : v }
  elsif junction_map.key?(v1)
    junction_map[v2] = junction_map[v1]
  elsif junction_map.key?(v2)
    junction_map[v1] = junction_map[v2]
  else
    @next_id += 1

    junction_map[v1] = @next_id
    junction_map[v2] = @next_id
  end

  nil
end

# Part 1
def part_one(points)
  c = points.combination(2).sort_by { |v1, v2| v1.distance(v2) }.take(1000)
  junction_map = {}

  c.each do |v1, v2|
    step(v1, v2, junction_map)
  end

  junction_map.group_by { |_, v| v }.values.map(&:count).sort.reverse.take(3).reduce(1, &:*)
end

# Part 2
def part_two(points)
  c = points.combination(2).sort_by { |v1, v2| v1.distance(v2) }
  junction_map = {}

  c.each do |v1, v2|
    step(v1, v2, junction_map)

    return v1.x * v2.x if junction_map.count == points.count
  end

  nil
end

# Data
lines = File.read("input.txt").split("\n")
points = lines.map { |line| Vec3.new(*line.split(",").map(&:to_i)) }

# Results
puts part_one(points)
puts part_two(points)
