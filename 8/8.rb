require_relative '../helpers'

DisplayInfo = Struct.new(:patterns, :digits)

def read_input(file_path)
  input = File.read(file_path).split("\n").map { |line| line.split(' | ') }
  input.map! do |line|
    DisplayInfo.new(line[0].split(' ').map(&:chars), line[1].split(' ').map(&:chars))
  end
end

def count_seq_of_lengths(seqs, lengths)
  seqs.count { |seq| lengths.include? seq.length }
end

def count_easy_digits(input)
  count = 0
  input.each do |line|
    count += count_seq_of_lengths(line.digits, [2, 4, 3, 7])
  end
  count
end

def find_seq_by_length(seqs, len)
  seqs.find { |seq| seq.length == len }
end

def find_common_chars(*seqs)
  # Find intersection between all sequences
  seqs.inject(:&)
end

def find_mapping(line)
  solution = Hash[%w[a b c d e f g].collect { |k| [k.to_sym, nil] }]
  # Find the patterns for 1, 4 and 7 (easily recognizable by length)
  # and find the 3 numbers with 6 segments (0, 6 and 9)
  one = find_seq_by_length(line.patterns, 2)
  seven = find_seq_by_length(line.patterns, 3)
  four = find_seq_by_length(line.patterns, 4)
  digits_with_six_segs = line.patterns.select { |seq| seq.length == 6 }

  # 1) Find C, F and A
  # Extract the two chars in common from 1 and 7, which are c and f.
  encoded_c_and_f = find_common_chars(one, seven)

  # In 0, 6 and 9, f is in the 3 digits. c appears only twice, so
  # their intersection will return f. The other letter will be c.
  encoded_f = find_common_chars(encoded_c_and_f, *digits_with_six_segs)[0]
  encoded_c = encoded_c_and_f.find { |char| char != encoded_f }

  # Go back to 7: the remaining char will be a.
  encoded_a = (seven - encoded_c_and_f)[0]

  solution[encoded_f.to_sym] = 'f'
  solution[encoded_c.to_sym] = 'c'
  solution[encoded_a.to_sym] = 'a'

  # 2) Find B and D
  # Go back to 4, remove c and f. The remaining two chars map to b and d.
  encoded_b_and_d = four - encoded_c_and_f
  # In 0, 6 and 9, b is in the 3 digits. d appears only twice, so
  # their intersection will return b.
  encoded_b = find_common_chars(encoded_b_and_d, *digits_with_six_segs)[0]
  encoded_d = encoded_b_and_d.find { |char| char != encoded_b }

  solution[encoded_b.to_sym] = 'b'
  solution[encoded_d.to_sym] = 'd'

  # 4) Find E and G
  # Only e and g remaining. In 0, 6, and 9, g is in 3, e is in 2, so
  # their intersection will return g.
  encoded_g_and_e = solution.select { |_k, v| v.nil? }.keys.map(&:to_s)
  encoded_g = find_common_chars(encoded_g_and_e, *digits_with_six_segs)[0]
  encoded_e = encoded_g_and_e.find { |char| char != encoded_g }

  solution[encoded_g.to_sym] = 'g'
  solution[encoded_e.to_sym] = 'e'
  solution
end

def decode_number(mapping, line)
  num_segments = %w[abcefg cf acdeg acdfg bcdf abdfg abdefg acf abcdefg abcdfg]
  num_codes = Hash[num_segments.zip (0..9).to_a]
  num = 0
  pow = 3
  line.digits.each do |digit|
    digit.map! { |char| mapping[char.to_sym] }.sort!
    num += num_codes[digit.join('')] * 10**pow
    pow -= 1
  end
  num
end

def decode(input)
  input.inject(0) { |sum, line| sum + decode_number(find_mapping(line), line) }
end

run('1', :count_easy_digits, 26)
run('2', :decode, 61_229)
