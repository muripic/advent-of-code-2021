require './lib/helpers'

def read_input(file_path)
  File.read(file_path).split("\n").map { |row| row.chars.map(&:to_i) }
end

def in_range?(i, j, matrix)
  i.between?(0, matrix.length - 1) && j.between?(0, matrix[0].length - 1)
end

def adjs(i, j)
  (i - 1..i + 1).to_a.product((j - 1..j + 1).to_a).reject! { |e| e == [i, j] }
end

def increase_adjs(i, j, matrix, flashed)
  return unless matrix[i][j] > 9 && !flashed.include?([i, j])

  flashed.push([i, j])
  adjs(i, j).each do |k, l|
    if in_range?(k, l, matrix)
      matrix[k][l] += 1
      increase_adjs(k, l, matrix, flashed)
    end
  end
end

def step(matrix)
  flashed = []
  matrix.each_with_index do |row, i|
    row.each_with_index do |value, j|
      matrix[i][j] = value + 1
      increase_adjs(i, j, matrix, flashed)
    end
  end
  flashed.each { |i, j| matrix[i][j] = 0 }
  flashed.length
end

def move_hundred_steps(matrix)
  (0...100).sum { step(matrix) }
end

def synchronize(matrix)
  step = 0
  octopi = matrix.length * matrix[0].length
  loop do
    flashes = step(matrix)
    step += 1
    return step if flashes == octopi
  end
end

run(11, '1', :move_hundred_steps, 1656)
run(11, '2', :synchronize, 195)
