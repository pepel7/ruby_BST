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
end
