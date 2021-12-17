require_relative '../helpers'

def read_input(file_path)
  File.read(file_path).split("\n").map(&:chars)
end

class SyntaxAnalizer
  @@brackets = { '[': ']', '{': '}', '(': ')', '<': '>' }

  def initialize(input)
    @input = input
    @illegal_chars = []
    @incomplete_lines = []
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
        return
      end
    end
    # Store stacks of incomplete lines
    @incomplete_lines.push(stack) unless stack.empty?
  end

  def analyze
    @input.each { |line| analyze_line(line) }
  end

  def corruption_score
    values = { ')': 3, ']': 57, '}': 1197, '>': 25_137 }
    @illegal_chars.sum(0) { |char| values[char.to_sym] }
  end

  def completion_strings
    @incomplete_lines.map { |line| line.reverse.map { |char| @@brackets[char.to_sym] } }
  end

  def autocomplete_score
    values = { ')': 1, ']': 2, '}': 3, '>': 4 }
    scores = completion_strings.map do |str|
      str.reduce(0) { |score, char| score * 5 + values[char.to_sym] }
    end
    scores.sort![scores.length / 2]
  end
end

puts '|*-*-* PART 1 *-*-*|'
puts 'Running test...'
test_syntax_analyzer = SyntaxAnalizer.new(read_input('test_input.txt'))
test_syntax_analyzer.analyze
expected_res = 26_397
print_test_message(test_syntax_analyzer.corruption_score, expected_res)

puts 'Running on given input...'
syntax_analyzer = SyntaxAnalizer.new(read_input('input.txt'))
syntax_analyzer.analyze
puts "Result: #{syntax_analyzer.corruption_score}."

puts '|*-*-* PART 2 *-*-*|'
puts 'Running test...'
expected_res = 288_957
print_test_message(test_syntax_analyzer.autocomplete_score, expected_res)

puts 'Running on given input...'
puts "Result: #{syntax_analyzer.autocomplete_score}."
