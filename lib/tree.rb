require_relative './node'

class Tree
  attr_reader :array, :root

  def initialize(arr)
    @array = arr.sort.uniq
    @root = build_tree(array)
  end

  def build_tree(arr)
    return if arr.empty?

    middle = (arr.length - 1) / 2
    node = Node.new(arr[middle])

    node.left = build_tree(arr[0...middle])
    node.right = build_tree(arr[middle + 1..])

    node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, current = root)
    return Node.new(value) if current.nil?

    current.left = insert(value, current.left) if current > value
    current.right = insert(value, current.right) if current < value

    current
  end

  def delete(value, current = root)
    return current if current.nil?

    if current > value
      current.left = delete(value, current.left)
    elsif current < value
      current.right = delete(value, current.right)
    else
      # We reach here when root is the node to be deleted.

      # If node has one or no child
      current.right if current.left.nil?
      current.left if current.right.nil?

      delete_if_two_children(current)
    end
    current
  end

  def find(value)
    level_order { |node| return node if node == value }
  end

  def level_order
    queue = [@root]
    arr = []
    until queue.empty?
      current = queue.shift
      block_given? ? yield(current) : arr << current.data

      queue << current.left unless current.left.nil?
      queue << current.right unless current.right.nil?
    end
    arr unless block_given?
  end

  def preorder(current = @root, arr = [], &block)
    return block_given? ? nil : arr if current.nil?

    block_given? ? yield(current) : arr << current.data

    preorder(current.left, arr, &block)
    preorder(current.right, arr, &block)
  end

  def inorder(current = @root, arr = [], &block)
    return block_given? ? nil : arr if current.nil?

    inorder(current.left, arr, &block)

    block_given? ? yield(current) : arr << current.data

    inorder(current.right, arr, &block)
  end

  def postorder(current = @root, arr = [], &block)
    return if current.nil?

    postorder(current.left, arr, &block)
    postorder(current.right, arr, &block)

    block_given? ? yield(current) : arr << current.data

    block_given? ? nil : arr
  end

  def height(node = @root)
    return -1 if node.nil?

    [height(node.left), height(node.right)].max + 1
  end

  def depth(node, current = @root)
    return 0 if current == node

    depth = depth(node, current.left) if node < current
    depth = depth(node, current.right) if node > current

    depth + 1
  end

  def balanced?(current = @root)
    return if current.nil?

    left_h = height(current.left)
    right_h = height(current.right)

    (left_h - right_h).abs <= 1
  end

  def rebalance
    initialize(inorder)
  end

  private

  def delete_if_two_children(current)
    mostleft_node = mostleft_leaf(current.right)
    current.data = mostleft_node.data
    current.right = delete(mostleft_node.data, current.right)
  end

  def mostleft_leaf(node)
    node = node.left until node.left.nil?
    node
  end
end
