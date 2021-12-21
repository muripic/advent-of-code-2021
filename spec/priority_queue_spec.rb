require 'priority_queue'

# FIXME: learn how to use fixtures and create functions to avoid repetition

RSpec.describe PriorityQueue, '#empty?' do
  context 'when no elements were added' do
    it 'returns true' do
      queue = PriorityQueue.new
      expect(queue.empty?).to eq true
    end
  end
end

RSpec.describe PriorityQueue, '#empty?' do
  context 'when elements were added' do
    it 'returns false' do
      queue = PriorityQueue.new
      queue.push('a', 2)
      queue.push('b', 1)
      expect(queue.empty?).to eq false
    end
  end
end

RSpec.describe PriorityQueue, '#length' do
  context 'when no elements were added' do
    it 'returns 0' do
      queue = PriorityQueue.new
      expect(queue.length).to eq 0
    end
  end
end

RSpec.describe PriorityQueue, '#length' do
  context 'when 3 elements were added and 1 was removed' do
    it 'returns 2' do
      queue = PriorityQueue.new
      queue.push('a', 2)
      queue.push('b', 1)
      queue.push('c', 3)
      queue.pop
      expect(queue.length).to eq 2
    end
  end
end

RSpec.describe PriorityQueue, '#push' do
  context 'when only the element "a" is added' do
    it 'the next element in the queue is "a"' do
      queue = PriorityQueue.new
      queue.push('a', 40)
      expect(queue.next).to eq ['a', 40]
    end
  end
end

RSpec.describe PriorityQueue, '#push' do
  context 'when the elements and priorities (a, 40), (b, 10), (c, 30), (d, 35), (e, 32), (f, 20), (g, 25) are added' do
    it 'the next element in the queue is "b"' do
      queue = PriorityQueue.new
      input = [['a', 40], ['b', 10], ['c', 30], ['d', 35], ['e', 32], ['f', 20], ['g', 25]]
      input.each { |elem, priority| queue.push(elem, priority) }
      expect(queue.next).to eq ['b', 10]
    end
  end
end
