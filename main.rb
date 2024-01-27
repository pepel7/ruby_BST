require_relative './lib/tree'
p [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324].uniq.sort
arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324].uniq.sort
tree = Tree.new(arr)

tree.build_tree(arr, 0, arr.length - 1)

tree.pretty_print

p tree.height(tree.root.right)

# tree.pretty_print
