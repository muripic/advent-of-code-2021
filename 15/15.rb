def read_input(file_path)
  File.read(file_path).split("\n").map { |row| row.chars.map(&:to_i) }
end

matrix = read_input('test_input.txt')
