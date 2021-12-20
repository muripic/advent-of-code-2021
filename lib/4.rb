require './lib/helpers'

class Board
  def initialize(numbers)
    @numbers = numbers
    @checked = 0
    @rows = [0] * 5
    @columns = [0] * 5
  end

  def cross_number(n)
    (0...5).each do |i|
      (0...5).each do |j|
        next unless @numbers[i][j] == n

        @numbers[i][j] = 'X'
        @rows[i] += 1
        @columns[j] += 1
      end
    end
  end

  def print
    @numbers.each { |row| puts row.join(' ') }
  end

  def check_result
    @rows.each { |n| return true if n == 5 }
    @columns.each { |n| return true if n == 5 }
    false
  end

  def sum_numbers
    sum = 0
    (0...5).each do |i|
      (0...5).each do |j|
        sum += @numbers[i][j] if @numbers[i][j].is_a? Integer
      end
    end
    sum
  end
end

Input = Struct.new(:numbers, :boards)

def read_input(file_path)
  input = File.read(file_path).split("\n")
  Input.new(read_numbers(input), read_boards(input))
end

def read_numbers(input)
  input[0].split(',').map(&:to_i)
end

def read_boards(input)
  # Ignore first line (numbers) and empty lines
  raw_boards = input[1, input.length - 1].reject(&:empty?)
  # Board size is 5x5
  raw_boards.each_slice(5).map do |slice|
    Board.new(slice.map! { |row| row.split(' ').map(&:to_i) })
  end
end

class Bingo
  attr_reader :last_number, :winners, :boards

  def initialize(numbers, boards)
    @numbers = numbers
    @boards = Hash[(0...boards.size).zip boards]
    @last_number = nil
    @winners = {}
    @active_boards = boards.length
  end

  def play(lose = false)
    @numbers.each do |n|
      @boards.each do |k, b|
        b.cross_number(n)
        next unless b.check_result

        @last_number = n
        @winners[k] = b unless @winners.key?(k)
        return k unless lose
        return k if @winners.length == @boards.size
      end
    end
  end

  def print_winners
    @winners.each do |k, b|
      puts "Board #{k}"
      b.print
    end
  end

  def score(board)
    @boards[board].sum_numbers * @last_number
  end
end

puts '|*-*-* PART 1 *-*-*|'
puts 'Running test...'
test_input = read_input('input/4/test_input.txt')
test_bingo = Bingo.new(test_input.numbers, test_input.boards)
winner = test_bingo.play
print_test_message(test_bingo.score(winner), 4512)

puts 'Running on given input...'
input = read_input('input/4/input.txt')
bingo = Bingo.new(input.numbers, input.boards)
winner = bingo.play
puts "Result: #{bingo.score(winner)}."

puts '|*-*-* PART 2 *-*-*|'
puts 'Running test...'
test_bingo = Bingo.new(test_input.numbers, test_input.boards)
winner = test_bingo.play(true)
print_test_message(test_bingo.score(winner), 1924)

puts 'Running on given input...'
bingo = Bingo.new(input.numbers, input.boards)
winner = bingo.play(true)
puts "Result: #{bingo.score(winner)}."
