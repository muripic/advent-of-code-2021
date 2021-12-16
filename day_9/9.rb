require_relative '../helpers'

def read_input(file_path)
  File.read(file_path).split("\n").map { |row| row.chars.map(&:to_i) }
end

class HeightMap
  attr_reader :low_points, :basin_sizes

  def initialize(matrix)
    @matrix = matrix
    @rows = matrix.length
    @cols = matrix[0].length
    @low_points = []
    @basin_sizes = Hash.new(0)
  end

  def adj_heights(i, j)
    adj = []
    [i - 1, i + 1].each { |k| adj.push(@matrix[k][j]) if k.between?(0, @rows - 1) }
    [j - 1, j + 1].each { |k| adj.push(@matrix[i][k]) if k.between?(0, @cols - 1) }
    adj
  end

  def low_point?(height, adj_heights)
    height < adj_heights.min
  end

  def calculate_low_points
    (0...@rows).each do |i|
      (0...@cols).each do |j|
        @low_points.push([i, j]) if low_point?(@matrix[i][j], adj_heights(i, j))
      end
    end
  end

  def risk_level
    risk_lvl = @low_points.sum { |i, j| @matrix[i][j] }
    risk_lvl + @low_points.length
  end

  def find_basin_sizes
    @low_points.each { |i, j| find_basin(i, j, "#{i},#{j}") }
  end

  def find_basin(i, j, basin_key)
    @basin_sizes[basin_key] += 1
    value = @matrix[i][j]
    @matrix[i][j] = 9
    if (i - 1).between?(0, @rows - 1) && @matrix[i - 1][j] > value && @matrix[i - 1][j] != 9
      find_basin(i - 1, j, basin_key)
    end
    if (i + 1).between?(0, @rows - 1) && @matrix[i + 1][j] > value && @matrix[i + 1][j] != 9
      find_basin(i + 1, j, basin_key)
    end
    if (j - 1).between?(0, @cols - 1) && @matrix[i][j - 1] > value && @matrix[i][j - 1] != 9
      find_basin(i, j - 1, basin_key)
    end
    if (j + 1).between?(0, @cols - 1) && @matrix[i][j + 1] > value && @matrix[i][j + 1] != 9
      find_basin(i, j + 1, basin_key)
    end
  end
end

puts '|*-*-* PART 1 *-*-*|'
puts 'Running test...'
test_height_map = HeightMap.new(read_input('test_input.txt'))
test_height_map.calculate_low_points
res = test_height_map.risk_level
expected_res = 15
print_test_message(res, expected_res)

puts 'Running on given input...'
height_map = HeightMap.new(read_input('input.txt'))
height_map.calculate_low_points
res = height_map.risk_level
puts "Result: #{res}."

puts '|*-*-* PART 2 *-*-*|'
puts 'Running test...'
test_height_map.find_basin_sizes
res = test_height_map.basin_sizes.values.max(3).inject(&:*)
expected_res = 1134
print_test_message(res, expected_res)

puts 'Running on given input...'
height_map.find_basin_sizes
res = height_map.basin_sizes.values.max(3).inject(&:*)
puts "Result: #{res}."
