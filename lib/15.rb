require './lib/priority_queue'
require './lib/helpers'

def read_input(file_path)
  File.read(file_path).split("\n").map { |row| row.chars.map(&:to_i) }
end

class Graph
  attr_reader :start, :end

  def initialize(matrix)
    @matrix = matrix
    @rows = matrix.length
    @cols = matrix[0].length
    @start = [0, 0]
    @end = [@rows - 1, @cols - 1]
  end

  def in_range?(i, j)
    i >= 0 && i < @rows && j >= 0 && j < @cols
  end

  def neighbors(position)
    i, j = position
    [[i + 1, j], [i - 1, j], [i, j + 1], [i, j - 1]].select { |x, y| in_range?(x, y) }
  end

  def cost(position)
    i, j = position
    @matrix[i][j]
  end

  def heuristic(position)
    # Manhattan distance
    i, j = position
    (@end[0] - i).abs + (@end[1] - j).abs
  end

  def find_lowest_risk
    # A*
    frontier = PriorityQueue.new
    frontier.push(@start, 0)
    cost_so_far = {}
    cost_so_far[@start] = 0

    until frontier.empty?
      current = frontier.pop[0]
      break if current == @end

      neighbors(current).each do |nxt|
        new_cost = cost_so_far[current] + cost(nxt)
        next unless !cost_so_far.include?(nxt) || new_cost < cost_so_far[nxt]

        cost_so_far[nxt] = new_cost
        priority = new_cost + heuristic(nxt)
        frontier.push(nxt, priority)
      end
    end
    cost_so_far[@end]
  end
end

# PART 2: functions to expand matrix

def increase_by(elem, n)
  elem + n < 10 ? elem + n : (elem + n) % 9
end

def generate_increased_matrices(matrix)
  matrices = {}
  matrices[0] = matrix
  (1..8).each do |incr|
    matrices[incr] = matrix.map { |row| row.map { |elem| increase_by(elem, incr) } }
  end
  matrices
end

def concat_matrix_right(a, b)
  a.each_with_index { |row, i| row.concat(b[i]) }
end

def get_expanded_row(slc, matrices)
  first = matrices[slc.first]
  slc[1..-1].each { |incr| concat_matrix_right(first, matrices[incr]) }
  first
end

def expand_matrix(matrix)
  matrices = generate_increased_matrices(matrix)
  new_matrix = []
  (0..8).each_cons(5) { |slc| new_matrix.concat(get_expanded_row(slc, matrices)) }
  new_matrix
end

def run(matrix)
  graph = Graph.new(matrix)
  graph.find_lowest_risk
end

test_matrix = read_input('input/15/test_input.txt')
matrix = read_input('input/15/input.txt')

puts '|*-*-* PART 1 *-*-*|'
puts 'Running test...'
print_test_message(run(test_matrix), 40)

puts 'Running on given input...'
puts "Result: #{run(matrix)}."

puts '|*-*-* PART 2 *-*-*|'
puts 'Running test...'
print_test_message(run(expand_matrix(test_matrix)), 315)

puts 'Running on given input...'
puts "Result: #{run(expand_matrix(matrix))}."
