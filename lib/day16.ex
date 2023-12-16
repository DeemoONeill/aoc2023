defmodule Day16 do
  @left {0, -1}
  @up {-1, 0}
  @down {1, 0}
  @right {0, 1}

  def main() do
    grid = File.read!("inputs/day16.txt") |> AOC.parse_grid

    grid |> part1 |> IO.inspect(label: "part 1")
    grid |> part2 |> IO.inspect(label: "part 2")
  end

  def part1(grid), do: part1(grid, {0, 0}, @right)

  def part1(grid, start_pos, start_dir) do
    move(start_pos, grid, start_dir, MapSet.new())
    |> Enum.map(&elem(&1, 0))
    |> MapSet.new()
    |> MapSet.size()
  end

  def part2(grid) do
    {max_y, max_x} = grid |> Map.keys() |> Enum.max()

    [
      Enum.map(0..max_y, fn y -> Task.async(fn -> part1(grid, {y, 0}, @right) end) end),
      Enum.map(0..max_y, fn y -> Task.async(fn -> part1(grid, {y, max_x}, @left) end) end),
      Enum.map(0..max_x, fn x -> Task.async(fn -> part1(grid, {0, x}, @down) end) end),
      Enum.map(0..max_x, fn x -> Task.async(fn -> part1(grid, {max_y, x}, @up) end) end)
    ]
    |> List.flatten()
    |> Task.await_many()
    |> Enum.max()
  end

  def move(point, grid, direction, visited) do
    symbol = unless {point, direction} in visited, do: grid[point]
    visited = if symbol == nil, do: visited, else: update(visited, point, direction)

    case {symbol, direction} do
      {nil, _} ->
        visited

      {".", dir} ->
        move(next(point, dir), grid, dir, visited)

      {"\\", {y, x}} ->
        move(next(point, {x, y}), grid, {x, y}, visited)

      {"/", {y, x}} ->
        move(next(point, {-x, -y}), grid, {-x, -y}, visited)

      {"|", dir} when dir == @left or dir == @right ->
        move(next(point, @down), grid, @down, visited)
        |> then(&move(next(point, @up), grid, @up, &1))

      {"|", dir} ->
        move(next(point, dir), grid, dir, visited)

      {"-", dir} when dir == @up or dir == @down ->
        move(next(point, @right), grid, @right, visited)
        |> then(&move(next(point, @left), grid, @left, &1))

      {"-", dir} ->
        move(next(point, dir), grid, dir, visited)
    end
  end

  def next(point, dir)
  def next({y1, x1}, {y2, x2}), do: {y1 + y2, x1 + x2}
  def update(visited, point, direction), do: MapSet.put(visited, {point, direction})
end
