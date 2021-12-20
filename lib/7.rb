require './lib/helpers'

def read_input(file_path)
  File.read(file_path).split(',').map(&:to_i)
end

def gauss_sum(n)
  n * (n + 1) / 2
end

def get_min_constant_fuel_consumption(crab_positions)
  distances = Array.new(crab_positions.max + 1, 0)
  (0..crab_positions.max).each do |i|
    crab_positions.each { |pos| distances[i] += (pos - i).abs }
  end
  distances.min
end

def get_min_variable_fuel_consumption(crab_positions)
  distances = Array.new(crab_positions.max + 1, 0)
  (0..crab_positions.max).each do |i|
    crab_positions.each { |pos| distances[i] += gauss_sum((pos - i).abs) }
  end
  distances.min
end

run(7, '1', :get_min_constant_fuel_consumption, 37)
run(7, '2', :get_min_variable_fuel_consumption, 168)
