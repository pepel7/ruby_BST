require_relative './node'

class Tree
  attr_accessor :array, :root

  def initialize(arr)
    @array = arr
    @root = nil
  end

  def build_tree(arr, start, ending)
    return if start > ending

    mid = (start + ending) / 2
    node = Node.new(arr[mid])

    node.left = build_tree(arr, start, mid - 1)
    node.right = build_tree(arr, mid + 1, ending)
    @root = node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, current = @root)
    return Node.new(value) if current.nil?

    current.left = insert(value, current.left) if current > value
    current.right = insert(value, current.right) if current < value

    current
  end

  def delete(value, current = @root)
    return current if current.nil?

    # Recursive calls for ancestors of the node to be deleted
    if current > value
      current.left = delete(value, current.left)
      return current
    elsif current < value
      current.right = delete(value, current.right)
      return current
    end

    # We reach here when root is the node to be deleted.

    # If one of the children is empty
    if current.left.nil?
      delete_if_right_child_exists(current)
    elsif current.right.nil?
      delete_if_left_child_exists(current)
    # If both children exist
    else
      delete_if_both_childs_exist(current)
    end
  end

  def find(value, current = @root)
    return nil if current.nil?
    return current if current == value

    find(value, current.left) if current > value
    find(value, current.right) if current < value
  end

  def level_order(current = nil, queue = [@root], arr = [], &block)
    return block_given? ? nil : arr if queue.empty?

    current = queue.shift # rubocop:disable Lint/ShadowedArgument

    yield(current) if block_given?
    arr << current.data

    queue << current.left unless current.left.nil?
    queue << current.right unless current.right.nil?

    level_order(current, queue, arr, &block)
  end

  private

  def delete_if_right_child_exists(current)
    temp = current.right
    current = nil
    temp
  end

  def delete_if_left_child_exists(current)
    temp = current.left
    current = nil
    temp
  end

  def delete_if_both_childs_exist(current)
    successor_parent = current # Now it's the node to be deleted!

    # Find successor
    successor = current.right
    until successor.left.nil?
      successor_parent = successor
      successor = successor.left
    end

    # Delete successor. Since successor is always left child of its parent
    # we can safely make successor's right right child as left of its parent.
    # If there is no successor,
    # then assign successor.right to successor_parent.right
    if successor_parent != current
      successor_parent.left = successor.right
    else
      successor_parent.right = successor.right
    end

    current.data = successor.data

    current
  end
end
