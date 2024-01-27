class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def <=>(other)
    return data <=> other.data if other.is_a?(Node)

    data <=> other
  end
end
