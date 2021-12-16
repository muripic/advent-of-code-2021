def read_input(file_path)
  File.read(file_path).split("\n").map { |row| row.chars.map(&:to_i) }
end

class HeightMap
  attr_reader :low_points

  def initialize(matrix)
    @matrix = matrix
    @rows = matrix.length
    @cols = matrix[0].length
    @low_points = []
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
        @low_points.push(@matrix[i][j]) if low_point?(@matrix[i][j], adj_heights(i, j))
      end
    end
  end

  def risk_level
    @low_points.sum + @low_points.length
  end
end

def run(file_path)
  height_map = HeightMap.new(read_input(file_path))
  height_map.calculate_low_points
  height_map.risk_level
end

puts '|*-*-* PART 1 *-*-*|'
puts 'Running test...'
res = run('test_input.txt')
expected_res = 15
if res == expected_res
  puts "Yay! Test passed with expected result #{res}."
else
  puts "Try again! Test failed with result #{res}, but expected #{expected_res}."
end

puts 'Running on given input...'
res = run('input.txt')
puts "Result: #{res}."
