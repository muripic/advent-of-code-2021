require_relative '../helpers'

def read_input(file_path)
  File.read(file_path).split.map(&:to_i)
end

def count_increases(measurements)
  count = 0
  measurements.each_cons(2) { |n, m| count += 1 if n < m }
  count
end

def count_increases_by_three(measurements)
  count = 0
  measurements.each_cons(3).map(&:sum).each_cons(2) { |n, m| count += 1 if n < m }
  count
end

run('1', :count_increases, 7)
run('2', :count_increases_by_three, 5)
