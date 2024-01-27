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

  def insert(value, root = @root)
    return Node.new(value) if root.nil?

    root.left = insert(value, root.left) if root > value
    root.right = insert(value, root.right) if root < value

    root
  end

  def delete(value, root = @root)
    return root if root.nil?

    # Recursive calls for ancestors of the node to be deleted
    if root.data > value
      root.left = delete(value, root.left)
      return root
    elsif root.data < value
      root.right = delete(value, root.right)
      return root
    end

    # We reach here when root is the node to be deleted.

    # If one of the children is empty
    if root.left.nil?
      delete_if_right_child_exists(root)
    elsif root.right.nil?
      delete_if_left_child_exists(root)
    # If both children exist
    else
      delete_if_both_childs_exist(root)
    end
  end

  private

  def delete_if_right_child_exists(root)
    temp = root.right
    root = nil
    temp
  end

  def delete_if_left_child_exists(root)
    temp = root.left
    root = nil
    temp
  end

  def delete_if_both_childs_exist(root)
    successor_parent = root

    # Find successor
    successor = root.right
    until successor.left.nil?
      successor_parent = successor
      successor = successor.left
    end

    # Delete successor. Since successor is always left child of its parent
    # we can safely make successor's right right child as left of its parent.
    # If there is no succ, then assign succ.right to succParent.right
    if successor_parent != root
      successor_parent.left = successor.right
    else
      successor_parent.right = successor.right
    end

    root.data = successor.data

    successor = nil
    root
  end
end
