require './lib/helpers'

def read_input(file_path)
  File.read(file_path).split("\n").map(&:chars).map { |num| num.map(&:to_i) }
end

# ----- PART 1 ------

def arr_to_binary_int(arr)
  arr.join('').to_i(2)
end

def get_gamma_epsilon_product(report)
  ones_per_pos = report.transpose.map(&:sum)
  gamma = ones_per_pos.map { |ones| ones > report.length - ones ? 1 : 0 }
  epsilon = ones_per_pos.map { |ones| ones > report.length - ones ? 0 : 1 }
  arr_to_binary_int(gamma) * arr_to_binary_int(epsilon)
end

run(3, '1', :get_gamma_epsilon_product, 198)

# ----- PART 2 ------

def count_ones_in_pos(report, pos)
  report.inject(0) { |sum, n| sum + n[pos].to_i }
end

def keep_oxygen_digit(ones, zeros)
  ones >= zeros ? 1 : 0
end

def keep_scrubber_digit(ones, zeros)
  ones >= zeros ? 0 : 1
end

def find_candidate(report, condition)
  (0...report[0].length).each do |i|
    ones = count_ones_in_pos(report, i)
    zeros = report.length - ones
    report.each do
      report.select! { |n| n[i] == condition.call(ones, zeros) }
    end
    return report if report.length == 1
  end
end

def get_life_support_rating(report)
  # Make deep copies of report
  oxygen_report = report.select { |n| n }
  scrubber_report = report.select { |n| n }
  oxygen_res = find_candidate(oxygen_report, method(:keep_oxygen_digit))
  scrubber_res = find_candidate(scrubber_report, method(:keep_scrubber_digit))
  oxygen_res[0].join('').to_i(2) * scrubber_res[0].join('').to_i(2)
end

run(3, '2', :get_life_support_rating, 230)
