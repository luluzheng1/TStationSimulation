require 'minitest/autorun'

# require_relative 'graph'
# require_relative 'node'
require_relative 'breadth_first_search'

describe BreadthFirstSearch do
  before do
    @node1 = Node.new("Davis")
    @node2 = Node.new("Harvard")
    @node3 = Node.new("Kendall")
    @node4 = Node.new("Park")
    @node5 = Node.new("Downtown Crossing")
    @node6 = Node.new("Tufts")
    @node7 = Node.new("Magoun")
    @node8 = Node.new("East Sommerville")
    @node9 = Node.new("Lechmere")
    @node10 = Node.new("North Station")
    @node11 = Node.new("Government Center")
  end

  it 'finds the shortest path to a node' do
    graph = Graph.new
    graph.add_edge(@node1, @node2)
    graph.add_edge(@node2, @node3)
    graph.add_edge(@node3, @node4)
    graph.add_edge(@node4, @node5)
    graph.add_edge(@node6, @node7)
    graph.add_edge(@node7, @node8)
    graph.add_edge(@node8, @node9)
    graph.add_edge(@node9, @node10)
    graph.add_edge(@node10, @node11)
    graph.add_edge(@node4, @node11)

    path = BreadthFirstSearch.new(graph, @node1).shortest_path_to(@node10)

    path.must_equal [@node1, @node2, @node3, @node4, @node11, @node10]
  end
end