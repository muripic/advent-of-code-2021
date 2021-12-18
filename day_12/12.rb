require_relative '../helpers'

def read_input(file_path)
  lines = File.read(file_path).split("\n")
  lines.each_with_object({}) do |edge, hash|
    a, b = edge.split('-')
    hash[a] = hash.fetch(a, []).append(b)
    hash[b] = hash.fetch(b, []).append(a)
  end
end

def find_all_paths(graph)
  completed_paths = []
  active_paths = [['start']]
  active_paths.each do |path|
    graph[path[-1]].each do |nxt|
      if nxt == 'end'
        completed_paths.append(path + [nxt])
      elsif !path.include?(nxt) || /[[:upper:]]/.match(nxt)
        active_paths.append(path + [nxt])
      end
    end
  end
  completed_paths
end

puts '|*-*-* PART 1 *-*-*|'

puts 'Running test 1...'
print_test_message(find_all_paths(read_input('test_input_1.txt')).length, 10)

puts 'Running test 2...'
print_test_message(find_all_paths(read_input('test_input_2.txt')).length, 19)

puts 'Running test 3...'
print_test_message(find_all_paths(read_input('test_input_3.txt')).length, 226)
