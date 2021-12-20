Point = Struct.new(:x, :y)

def read_input(_file_path)
  lines = File.read('input.txt').split("\n")
  points = lines.each_with_object([]) do |line, pts|
    if line.include?(',')
      x, y = line.split(',').map!(&:to_i)
      pts << Point.new(x, y)
    end
  end
  folds = lines.select { |line| line if line.include?('fold') }
  folds.map! { |line| line.split('=') }
  [points, folds]
end

def fold(points, axis, value)
  folded_points = []
  if axis == 'y'
    # Horizontal fold
    points.each do |pt|
      # New y is equal to prev y - (distance fo prev y to fold)*2
      folded_points << (pt.y >= value ? Point.new(pt.x, pt.y - (pt.y - value) * 2) : pt)
    end
  elsif axis == 'x'
    # Vertical fold
    points.each do |pt|
      folded_points << (pt.x >= value ? Point.new(pt.x - (pt.x - value) * 2, pt.y) : pt)
    end
  end
  folded_points
end

def fold_once(points, folds)
  fold = folds[0]
  fold(points, fold[0][-1], fold[1].to_i).tally.count
end

def fold_all(points, folds)
  folds.each do |axis, value|
    points = fold(points, axis[-1], value.to_i)
  end
  points
end

def draw(points)
  rows = points.map(&:y).max + 1
  cols = points.map(&:x).max + 1
  matrix = Array.new(rows) { Array.new(cols, '.') }
  points.each do |pt|
    matrix[pt.y][pt.x] = 'X'
  end
  matrix.each { |row| puts row.join(' ') }
end

points, folds = read_input('input.txt')

puts '|*-*-* PART 1 *-*-*|'

puts fold_once(points, folds)

puts '|*-*-* PART 2 *-*-*|'

points = fold_all(points, folds)
draw(points)
