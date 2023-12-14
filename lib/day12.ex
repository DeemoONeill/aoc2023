# defmodule Day12 do
#   defstruct grid: [], numbers: [], lengths: [], hashes: []

#   def new([grid, amounts]) do
#     grid = String.split(grid, ".", trim: true)

#     %Day12{
#       grid: grid,
#       numbers: String.split(amounts, ",") |> Enum.map(&String.to_integer/1),
#       lengths: grid |> Enum.map(&String.length/1),
#       hashes: grid |> Enum.map(&(String.replace(&1, "?", "") |> String.length()))
#     }
#   end

#   def parse(lines) do
#     lines
#     |> String.split()
#     |> Enum.chunk_every(2)
#     |> Enum.map(&new/1)
#   end

#   def main() do
#     rows = File.read!("inputs/day12.txt") |> parse

#     rows
#     |> part1
#     |> IO.inspect(label: "part 1")
#   end

#   def check_combinations(%Day12{numbers: list, lengths: list}), do: 1

#   def check_combinations(%Day12{grid: grid, numbers: numbers, lengths: lengths, hashes: hashes}) do
#     check_combinations(grid, numbers, lengths, hashes, 0)
#   end

#   def check_combinations(
#         grid,
#         [first_num | nums],
#         [first_length | lengths],
#         [first_hashes | hashes],
#         total
#       ) do
#     # number of blank spaces to work with
#     space_left = first_length - first_hashes

#     case {space_left, first_length, first_num, first_hashes} do
#       {space, _, num, num} when space > hd(nums) ->
#         nil
#     end
#   end

#   def part1(rows) do
#     rows |> Enum.map(&check_combinations/1)
#   end

#   def part2(_data) do
#   end
# end
