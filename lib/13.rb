require './lib/helpers'

def read_input(file_path)
  lines = File.read(file_path).split("\n")
  points = (lines.select { |ln| ln.include?(',') }).map { |ln| ln.split(',').map!(&:to_i) }
  folds = (lines.select { |ln| ln.include?('fold') }).map! { |ln| ln.split('=') }
  [points, folds]
end

def transform_pair(x, y, axis, value)
  if axis == 'y' && y >= value # Horizontal fold
    # New y is equal to prev y - (distance fo prev y to fold)*2
    [x, y - (y - value) * 2]
  elsif axis == 'x' && x >= value # Vertical fold
    [x - (x - value) * 2, y]
  else
    [x, y]
  end
end

def fold(points, axis, value)
  points.map { |x, y| transform_pair(x, y, axis, value) }
end

def fold_once(input)
  points, folds = input
  first_fold = folds[0]
  fold(points, first_fold[0][-1], first_fold[1].to_i).tally.count
end

def fold_all(points, folds)
  folds.inject(points) { |pts, fold| fold(pts, fold[0][-1], fold[1].to_i) }
end

def draw(points)
  rows = points.map(&:last).max + 1
  cols = points.map(&:first).max + 1
  matrix = Array.new(rows) { Array.new(cols, '.') }
  points.each { |x, y| matrix[y][x] = 'X' }
  (matrix.map { |row| row.join(' ') }).join("\n")
end

def fold_and_draw(input)
  points, folds = input
  draw(fold_all(points, folds))
end

expected_res_part_two = 'X X X X X
X . . . X
X . . . X
X . . . X
X X X X X'

run(13, '1', :fold_once, 17)
run(13, '2', :fold_and_draw, expected_res_part_two)
