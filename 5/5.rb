require_relative '../helpers'

def read_input(file_path)
  File.read(file_path).split("\n").map! do |ln|
    src, dst = ln.split(' -> ')
    Move.new(transform_coords(src), transform_coords(dst))
  end
end

Coordinates = Struct.new(:x, :y)

def transform_coords(coords_str)
  x, y = coords_str.split(',')
  Coordinates.new(x.to_i, y.to_i)
end

def coords_to_hash(coords)
  "#{coords.x},#{coords.y}"
end

class Move
  attr_reader :first, :second

  def initialize(first, second)
    @first = first
    @second = second
  end

  def vertical?
    @first.x == @second.x
  end

  def horizontal?
    @first.y == @second.y
  end

  def range
    range = []
    if vertical?
      # Move y
      y_minmax = [@first.y, @second.y].minmax
      (y_minmax[0]..y_minmax[1]).each do |y|
        range << Coordinates.new(@first.x, y)
      end
    elsif horizontal?
      # Move x
      x_minmax = [@first.x, @second.x].minmax
      (x_minmax[0]..x_minmax[1]).each do |x|
        range << Coordinates.new(x, @first.y)
      end
    else # is_diagonal
      # move both
      diff = (@first.x - @second.x).abs + 1
      x = @first.x
      y = @first.y
      diff.times do
        range.push(Coordinates.new(x, y))
        x = @first.x > @second.x ? x - 1 : x + 1
        y = @first.y > @second.y ? y - 1 : y + 1
      end
    end
    range
  end
end

def count_overlaps(input, diagonals)
  # Use a hash to store the coordinates
  coord_map = Hash.new(0)
  # Filter coordinates to leave only horizontal and vertical movements
  # (i.e. if x1 == x2 or y1 == y2)
  moves = diagonals ? input : input.select { |mv| mv.vertical? || mv.horizontal? }
  moves.each do |mv|
    mv.range.each { |coords| coord_map[coords_to_hash(coords)] += 1 }
  end
  coord_map.count { |_k, v| v > 1 }
end

def count_overlaps_part_one(input)
  count_overlaps(input, false)
end

def count_overlaps_part_two(input)
  count_overlaps(input, true)
end

run('1', :count_overlaps_part_one, 5)
run('2', :count_overlaps_part_two, 12)
