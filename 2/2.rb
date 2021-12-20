require_relative '../helpers'

def read_input(file_path)
  File.read(file_path).split("\n").map(&:split).map { |dir, units| [dir, units.to_i] }
end

def calculate_position(course)
  horizontal_pos = 0
  depth = 0
  course.each do |dir, units|
    case dir
    when 'forward' then horizontal_pos += units
    when 'down' then depth += units
    when 'up' then depth += -1 * units
    end
  end
  horizontal_pos * depth
end

def calculate_position_with_aim(course)
  horizontal_pos = 0
  depth = 0
  aim = 0
  course.each do |dir, units|
    case dir
    when 'forward'
      horizontal_pos += units
      depth += aim * units
    when 'down'
      aim += units
    when 'up'
      aim += -1 * units
    end
  end
  horizontal_pos * depth
end

run('1', :calculate_position, 150)
run('2', :calculate_position_with_aim, 900)
