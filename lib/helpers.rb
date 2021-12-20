def print_test_message(res, expected_res)
  if res == expected_res
    puts "Yay! Test passed with expected result: \n#{res}"
  else
    puts "Try again! Test failed with result: \n#{res} \nExpected: \n#{expected_res}"
  end
end

def run_test(day, method_to_test, expected_res)
  puts 'Running test...'
  test_input = read_input("input/#{day}/test_input.txt")
  res = method(method_to_test).call(test_input)
  print_test_message(res, expected_res)
end

def run_for_real(day, method_to_run)
  puts 'Running on given input...'
  input = read_input("input/#{day}/input.txt")
  res = method(method_to_run).call(input)
  puts "Result: \n#{res}"
end

def run(day, part, part_method, expected_test_res)
  puts "\n"
  puts "|*-*-* PART #{part.upcase} *-*-*|"
  run_test(day, part_method, expected_test_res)
  run_for_real(day, part_method)
  puts "\n"
end
