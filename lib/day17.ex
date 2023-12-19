# defmodule Day17 do
#   # defstruct

#   @up {-1, 0}
#   @down {1, 0}
#   @left {0, -1}
#   @right {0, 1}

#   def parse_to_graph(lines) do
#     grid = lines |> AOC.parse_grid()

#     goal =
#       Enum.max(grid |> Map.keys())

#     graph =
#       for {current, _weight} <- grid, reduce: %{} do
#         acc -> Map.put(acc, current, neighbors(current, grid))
#       end

#     {graph, goal}
#   end

#   def main() do
#     {graph, goal} =
#       File.read!("inputs/day17.txt")
#       |> parse_to_graph

#     graph
#     |> part1(goal)
#     |> IO.inspect(label: "part 1")
#   end

#   def neighbors({y1, x1}, grid) do
#     [@up, @down, @left, @right]
#     |> Enum.map(fn {y2, x2} ->
#       coord = {y1 + y2, x1 + x2}

#       case grid[coord] do
#         nil -> nil
#         val -> {coord, String.to_integer(val)}
#       end
#     end)
#     |> Enum.filter(& &1)
#   end

#   def part1(graph, goal) do
#     graph
#     |> bfs({0, 0}, goal)
#   end

#   def part2(_data) do
#   end

#   def bfs(graph, root, goal) do
#     queue = [root]
#     seen = MapSet.new(queue)

#     for _num <- Stream.cycle([0]), reduce: {queue, seen} do
#       {[{0, 0} | tail], set} ->
#         IO.inspect(graph[{0,0}])
#         {graph[{0, 0}], set}

#       {[{node, weight} | tail], set} when node == goal ->
#         throw(:done)

#       {[{node, weight} | tail], set} ->
#         new_nodes = graph[node] |> Enum.filter(fn {node, weight} -> node not in set end)
#         IO.inspect(MapSet.size(set))
#         {tail ++ new_nodes , MapSet.put(set, node)}

#     end
#   end
# end
