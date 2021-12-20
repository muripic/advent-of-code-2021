def read_input(file_path)
  input_lines = File.read(file_path).split("\n")
  template = input_lines[0].chars
  rules = input_lines[2..-1].each_with_object({}) do |line, hash|
    k, v = line.split(' -> ')
    hash[k.chars] = v
  end
  [template, rules]
end

template, rules = read_input('input.txt')
elems = rules.keys.flatten.uniq.to_h { |char| [char, 0] }
pairs = rules.keys.to_h { |pair| [pair, 0] }

# Count elements in template
template.each { |elem| elems[elem] += 1 }
template.each_cons(2) { |pair| pairs[pair] += 1 }

steps = 40

steps.times do
  existing_pairs = pairs.select { |_pair, count| count.positive? }
  existing_pairs.each do |pair, count|
    mid_elem = rules[pair]
    pair_one = [pair[0], mid_elem]
    pair_two = [mid_elem, pair[1]]
    elems[mid_elem] += count
    pairs[pair_one] += count
    pairs[pair_two] += count
    pairs[pair] -= count
  end
end

puts elems.max_by(&:last).last - elems.min_by(&:last).last
