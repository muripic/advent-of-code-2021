require './lib/helpers'

def read_input(file_path)
  File.read(file_path).split(',').map(&:to_i)
end

class LanternSchool
  def initialize(fish)
    @fish = Array.new(9, 0)
    populate(fish)
  end

  def populate(fish)
    fish.each { |f| @fish[f] += 1 }
  end

  def add_day
    newborns = @fish[0]
    # Shift adults
    @fish.insert(6, @fish.shift)
    # Shift babies
    @fish[6] += @fish[7]
    @fish[7] = @fish[8]
    @fish[8] = newborns
  end

  def move_forward_in_time(days)
    days.times { add_day }
  end

  def size
    @fish.sum
  end
end

def run(fish, days)
  lantern_school = LanternSchool.new(fish)
  lantern_school.move_forward_in_time(days)
  lantern_school.size
end

test_fish = read_input('input/6/test_input.txt')
fish = read_input('input/6/input.txt')

puts '|*-*-* PART 1 *-*-*|'
puts 'Running test...'
print_test_message(run(test_fish, 80), 5934)

puts 'Running on given input...'
puts "Result: #{run(fish, 80)}."

puts '|*-*-* PART 2 *-*-*|'
puts 'Running test...'
print_test_message(run(test_fish, 256), 26_984_457_539)

puts 'Running on given input...'
puts "Result: #{run(fish, 256)}."
