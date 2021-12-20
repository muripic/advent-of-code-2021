require './lib/helpers'

def read_input(file_path)
  lines = File.read(file_path).split("\n")
  lines.each_with_object({}) do |edge, hash|
    a, b = edge.split('-')
    hash[a] = hash.fetch(a, []).append(b)
    hash[b] = hash.fetch(b, []).append(a)
  end
end

def find_all_paths(graph, small_cave_condition)
  completed_paths = 0
  active_paths = [['start']]
  active_paths.each do |path|
    graph[path[-1]].each do |nxt|
      if nxt == 'end'
        completed_paths += 1
      elsif /[[:upper:]]/.match(nxt) || method(small_cave_condition).call(path, nxt)
        active_paths.append(path + [nxt])
      end
    end
  end
  completed_paths
end

def small_cave_condition_one(path, cave)
  !path.include?(cave)
end

def small_cave_visited_twice?(visits)
  (visits.select! { |k, v| /[[:lower:]]/.match(k) && v > 1 }).empty?
end

def small_cave_condition_two(path, cave)
  return false if cave == 'start'

  visits = path.tally
  # Cave has not been visited yet OR no other small cave has been visited twice
  visits.fetch(cave, 0).zero? || small_cave_visited_twice?(visits)
end

def run_test(id, condition, expected_result)
  input = read_input("input/12/test_input_#{id}.txt")
  puts "Running test #{id}..."
  print_test_message(find_all_paths(input, condition), expected_result)
end

def run_on_input(condition)
  puts 'Running on given input...'
  input = read_input('input/12/input.txt')
  puts "Result: #{find_all_paths(input, condition)}."
end

puts '|*-*-* PART 1 *-*-*|'

run_test(1, :small_cave_condition_one, 10)
run_test(2, :small_cave_condition_one, 19)
run_test(3, :small_cave_condition_one, 226)

run_on_input(:small_cave_condition_one)

puts '|*-*-* PART 2 *-*-*|'

run_test(1, :small_cave_condition_two, 36)
run_test(2, :small_cave_condition_two, 103)
run_test(3, :small_cave_condition_two, 3509)

run_on_input(:small_cave_condition_two)
