# frozen_string_literal: true

# Node class for nodes in tree
class Node
  attr_accessor :data, :left, :right 

  def initialize(data = nil,left = nil,right = nil)
    @data = data
    @left = left
    @right = right
  end
end

# Tree class for out balanced binary search tree
class Tree
  attr_accessor :root

  def initialize (array)
    @root = nil
    build_tree(array)
  end

  def create_nodes(array)
    return nil if array.empty?

    return Node.new(array[0]) if array.length == 1

    target = array.length/2
    left_arary = array[0..target - 1]
    right_array = array[target + 1..-1]
    Node.new(array[target],create_nodes(left_arary),create_nodes(right_array))
  end

  def build_tree(array)
    array = array.sort.uniq
    @root = create_nodes(array)
    @root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = @root)
    return nil if value == node.data
    if value < node.data
      return node.left = Node.new(value) if node.left.nil?

      insert(value, node.left)
    else 
      return node.right = Node.new(value) if node.right.nil?

      insert(value, node.right)
    end
    node 
  end

  def find(value, node = @root)
    return nil if node.nil?

    return node if node.data == value

    return find(value, node.left) if value < node.data
    return find(value, node.right) if value > node.data

  end

  def leftest_leaf(node)
    return leftest_leaf(node.left) unless node.left.nil?

    node
  end

  def delete(value, node = @root)
    return nil if node.nil?

    if node.data > value
      node.left = delete(value, node.left)

    elsif node.data < value
      node.right = delete(value, node.right)

    else
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      leftest_node = leftest_leaf(node.right)
      node.data = leftest_node.data
      node.right = delete(leftest_node.data, node.right)
    end
    node
  end

  def level_order(node = @root,queue = [],array = [])
    queue << node.left unless node.left.nil?
    queue << node.right unless node.right.nil?
    return array if queue.empty?

    array << node
    level_order(queue.shift, queue, array)
  end

  def level_order_block
    node_array = level_order
    if block_given?
      for node in node_array do
        yield node
      end
    else 
      node_array
    end 
  end

  def inorder(node = @root, array =[])
    inorder(node.left,array) unless node.left.nil?
    array << node
    inorder(node.right,array) unless node.right.nil? 
    array
  end

  def preorder(node = @root, array =[])
    array << node
    preorder(node.left,array) unless node.left.nil?
    preorder(node.right,array) unless node.right.nil? 
    array
  end

  def postorder(node = @root, array =[])
    postorder(node.left,array) unless node.left.nil?
    postorder(node.right,array) unless node.right.nil?
    array << node 
    array
  end

  def height (node,count = 0)
    return count if node.nil?
    return count if node.left.nil? && node.right.nil?

    arr = []
    unless node.left.nil?
      count_left = height(node.left, count + 1)
      arr << count_left
    end
    unless node.right.nil?
      count_right = height(node.right, count + 1)
      arr << count_right
    end
    arr.max
  end

  def depth(node,curr_node=@root,count=0)
    return count if curr_node == node
    return depth(node,curr_node.left,count+1) if node.data < curr_node.data
    return depth(node,curr_node.right,count+1) if node.data > curr_node.data
  end

  def balanced?(node = @root)
    return if node.nil?
    return false if (height(node.left)-height(node.right)).abs > 1
    balanced?(node.left)
    balanced?(node.right)
    true
  end

  def rebalance
    new_array = inorder
    values = new_array.map {|node| node.data}
    @root = nil
    build_tree(values)

  end
end
# test_array = [1,2,3,4,5,6,7,8]
# test_array2 = [5,1,89,213,44,1,66,24]

# bor = Tree.new(test_array)
# bor.pretty_print

# hrast = Tree.new(test_array2)
# hrast.pretty_print

# p hrast.find(5).data
# p bor.find(8)
# p bor.find(7)

# hrast.insert(7)
# hrast.pretty_print

# hrast.insert(2000)
# hrast.pretty_print

# hrast.insert(67)
# hrast.pretty_print

# p hrast.delete(89).data
# hrast.pretty_print

# hrast.level_order
# hrast.level_order_block {|node| print "#{node.data}, "}
# puts 'inorder '
# hrast.inorder.each {|node| print "#{node.data}, "}
# puts ' '
# puts 'preorder '
# hrast.preorder.each {|node| print "#{node.data}, "}
# puts ' '
# puts 'postorder '
# hrast.postorder.each {|node| print "#{node.data}, "}
# puts ' '

# p hrast.root.left.right.left.data
# puts hrast.height(hrast.root.left.right.left)

# p "height of root.right #{hrast.height(hrast.root.right)}"
# p "node: #{hrast.root.right.left.right.data}"
# p hrast.depth(hrast.root.right.left.right)

# p hrast.balanced? 

test_array = Array.new(15) {rand(1..100)}
test_tree = Tree.new(test_array)
test_tree.pretty_print
p test_tree.balanced?
test_tree.insert(111)
test_tree.insert(112)
test_tree.insert(113)
test_tree.insert(114)
test_tree.pretty_print
p test_tree.balanced?
test_tree.rebalance
test_tree.pretty_print
