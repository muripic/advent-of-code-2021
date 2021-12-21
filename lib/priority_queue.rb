# Data structure that behaves like a queue except that elements have an associated priority.
# The #next and #pop methods return the item with the next highest priority.
# Implemented using a heapified array.
class PriorityQueue
  def initialize
    @queue = []
  end

  # Returns true if the queue is empty, false otherwise.
  def empty?
    @queue.empty?
  end

  # Return true if the element is in the queue, false otherwise.
  def include_elem?(elem)
    @queue.find { |e| e[0] == elem }
  end

  # Returns the number of elements in the queue.
  def length
    @queue.length
  end

  # Returns the object with the next highest priority without removing it.
  def next
    @queue.first
  end

  # Returns the object with the next highest priority and removes it from the queue.
  def pop
    @queue[0], @queue[-1] = @queue[-1], @queue[0]
    max = @queue.pop
    heapify_down(0)
    max
  end

  def push(elem, priority)
    # Add an object to the queue with associated priority.
    @queue << [elem, priority]
    heapify_up(@queue.length - 1)
  end

  private

  def parent(index)
    (index - 1) / 2
  end

  def left_child(index)
    2 * index + 1
  end

  def right_child(index)
    2 * index + 2
  end

  def heapify_up(i)
    # Return if elem is root or if parent has higher priority than the child
    return if index.zero? || @queue[parent(index)][1] < @queue[index][1]

    # Swap the child with the parent and keep going up
    @queue[i], @queue[parent(i)] = @queue[parent(i)], @queue[i]
    heapify_up(parent(i))
  end

  def max_priority_child_i(index)
    [left_child(index), right_child(index)].min_by { |i| @queue[i][1] }
  end

  def heapify_down(i)
    # Return if we reach the bottom of the tree (current elem has no children)
    return if left_child(i) > @queue.size - 1

    # Get the child with the highest priority
    child = right_child(i) > @queue.size - 1 ? left_child(i) : max_priority_child_i(i)
    # Return if the parent has more priority than its children
    return if @queue[child][1] > @queue[i][1]

    # Swap parent and child
    @queue[i], @queue[child] = @queue[child], @queue[i]
    # Repeat the process until the parent has higher priority than its children
    heapify_down(child)
  end
end
