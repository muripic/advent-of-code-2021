require_relative '../helpers'

def read_input(file_path)
  File.read(file_path).split("\n").map(&:chars)
end

class SyntaxAnalizer
  @@brackets = { '[': ']', '{': '}', '(': ')', '<': '>' }
  @@scores = { ')': 3, ']': 57, '}': 1197, '>': 25_137 }

  def initialize(input)
    @input = input
    @illegal_chars = []
  end

  def opening?(char)
    @@brackets.keys.map(&:to_s).include?(char)
  end

  def analyze_line(line)
    stack = []
    line.each do |char|
      if opening?(char)
        stack.push(char)
      elsif @@brackets[stack.last.to_sym] == char
        stack.pop
      else
        @illegal_chars.push(char)
        break
      end
    end
  end

  def analyze
    @input.each { |line| analyze_line(line) }
  end

  def calculate_score
    @illegal_chars.reduce(0) { |score, char| score + @@scores[char.to_sym] }
  end
end

puts '|*-*-* PART 1 *-*-*|'
puts 'Running test...'
input = read_input('test_input.txt')
syntax_analyzer = SyntaxAnalizer.new(input)
syntax_analyzer.analyze
res = syntax_analyzer.calculate_score
expected_res = 26_397
print_test_message(res, expected_res)
