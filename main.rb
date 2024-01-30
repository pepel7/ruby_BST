require_relative './lib/tree'

arr = (Array.new(15) { rand(1..100) })
tree = Tree.new(arr)
tree.build_tree(arr)
puts "It's #{tree.balanced?} that the tree is proportional."
puts "All elements in level order: #{tree.level_order}"
puts "All elements in preorder: #{tree.preorder}"
puts "All elements in postorder: #{tree.postorder}"
puts "All elements in inorder: #{tree.inorder}"

tree.pretty_print

puts "\nUnbalancing the tree . . .\n\n"
5.times { tree.insert(rand(101..200)) }
puts "It's #{tree.balanced?} that the tree is proportional."

puts "\nRebalancing the tree . . .\n\n"

tree.rebalance
puts "It's #{tree.balanced?} that the tree is proportional."
puts "All elements in level order: #{tree.level_order}"
puts "All elements in preorder: #{tree.preorder}"
puts "All elements in postorder: #{tree.postorder}"
puts "All elements in inorder: #{tree.inorder}"

tree.pretty_print
