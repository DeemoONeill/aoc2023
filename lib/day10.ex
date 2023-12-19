defmodule Day10 do
  def start(map) do
    map |> Enum.filter(&(&1 |> elem(1) == "S")) |> hd
  end

  def main() do
    map = File.read!("inputs/day10.txt") |> AOC.parse_grid()

    starting_point = map |> start

    map
    |> part1(starting_point)
    |> IO.inspect(label: "part 1")

    map
    |> part2(starting_point)
    |> IO.inspect(label: "part 2")
  end

  def calculate_loop(starting_point, map) do
    [:north, :east, :south, :west]
    |> Enum.map(fn direction -> [direction, map[move(starting_point |> elem(0), direction)]] end)
    |> Enum.filter(fn [dir, res] -> is_valid?(dir, res) end)
    |> Enum.map(fn [direction, _] ->
      traverse(starting_point |> elem(0), direction, map, 0, [])
    end)
  end

  def part1(map, starting_point) do
    starting_point
    |> calculate_loop(map)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.filter(&(&1 |> elem(1) > 0))
    |> hd
    |> elem(1)
  end

  def traverse(_point, :finish, _map, count, visited) when count > 0, do: visited

  def traverse(starting_point, direction, map, count, visited) do
    next = move(starting_point, direction)

    traverse(
      next,
      next_direction(direction, map[next]),
      map,
      count + 1,
      [{starting_point, count} | visited]
    )
  end

  def is_valid?(direction, result) do
    case {direction, result} do
      {dir, "|"} when dir == :north or dir == :south -> true
      {dir, "-"} when dir == :east or dir == :west -> true
      {dir, "L"} when dir == :east or dir == :north -> true
      {dir, "J"} when dir == :west or dir == :north -> true
      {dir, "7"} when dir == :west or dir == :north -> true
      {dir, "F"} when dir == :east or dir == :south -> true
      _ -> false
    end
  end

  def next_direction(direction, result) do
    case {direction, result} do
      {:north, "|"} -> :north
      {:south, "|"} -> :south
      {:east, "-"} -> :east
      {:west, "-"} -> :west
      {:south, "L"} -> :east
      {:north, "L"} -> :east
      {:west, "L"} -> :north
      {:south, "J"} -> :west
      {:west, "J"} -> :north
      {:east, "J"} -> :north
      {:east, "7"} -> :south
      {:south, "7"} -> :west
      {:north, "7"} -> :west
      {:south, "F"} -> :east
      {:north, "F"} -> :east
      {:east, "F"} -> :south
      {:west, "F"} -> :south
      {_, "S"} -> :finish
    end
  end

  def move(starting, direction)
  def move({y, x}, :west), do: {y, x - 1}
  def move({y, x}, :east), do: {y, x + 1}
  def move({y, x}, :north), do: {y - 1, x}
  def move({y, x}, :south), do: {y + 1, x}

  def part2(map, starting_point) do
    points_list = calculate_loop(starting_point, map) |> hd

    points_list =
      ([starting_point | points_list] ++ [starting_point])
      |> Enum.map(&elem(&1, 0))

    # The area calculated by green assumes a distance of 1 between the pipes that are next
    # to each other. subtracting half the length around the loop (part 1) gives the total
    # area for this problem. +1 because off by 1
    (green(points_list) - part1(map, starting_point) + 1) |> round
  end

  @doc """
  Greens forumula for finding the area of an irregular polygon without
  splitting it into basic shapes.
  ref: https://math.blogoverflow.com/2014/06/04/greens-theorem-and-area-of-polygons/
  """
  def green(points_list) do
    points_list
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [{y1, x1}, {y2, x2}] -> (x2 + x1) * (y2 - y1) / 2 end)
    |> Enum.sum()
    |> abs
  end
end
