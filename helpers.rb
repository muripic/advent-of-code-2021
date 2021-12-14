def run_test(method_to_test, expected_res)
  puts 'Running test...'
  test_input = read_input('test_input.txt')
  res = method(method_to_test).call(test_input)
  if res == expected_res
    puts "Yay! Test passed with expected result #{res}."
  else
    puts "Try again! Test failed with result #{res}, but expected #{expected_res}."
  end
end

def run_for_real(method_to_run)
  puts 'Running on given input...'
  input = read_input('input.txt')
  res = method(method_to_run).call(input)
  puts "Result: #{res}."
end

def run(part, part_method, expected_test_res)
  puts "\n"
  puts "|*-*-* PART #{part.upcase} *-*-*|"
  run_test(part_method, expected_test_res)
  run_for_real(part_method)
  puts "\n"
end
