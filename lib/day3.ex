defmodule Day3 do
  def main() do
    grid =
      File.read!("inputs/day3.txt")
      |> build_grid

    grid
    |> part1()
    |> IO.inspect(label: "part 1")

    grid
    |> part2()
    |> IO.inspect(label: "part 2")
  end

  def build_grid(data) do
    parsed =
      data
      |> String.split()
      |> Enum.map(&String.trim/1)
      |> Enum.map(&parse_line/1)

    for {row, y} <- Enum.with_index(parsed), reduce: %{} do
      acc ->
        for {item, x} <- Enum.with_index(row), reduce: acc do
          map -> Map.put(map, {y, x}, item)
        end
    end
  end

  def part1(grid) do
    for {{y, x} = loc, val} <- grid, is_integer(val) do
      padding = [grid[{y, x + 1}], grid[{y, x + 2}]] |> Enum.count(&(&1 == "P"))
      if adjacent_to_punc?(grid, padding, loc), do: val, else: 0
    end
    |> Enum.sum()
  end

  def part2(grid) do
    for {loc, val} <- grid, val == "*" do
      case adjacent_numbers(grid, loc) do
        [num1, num2] -> num1 * num2
        _ -> 0
      end
    end
    |> Enum.sum()
  end

  def adjacent_to_punc?(grid, padding, {y, x}) do
    xs = (x - 1)..(x + padding + 1)
    left = {y, x - 1}
    right = {y, x + padding + 1}

    falsey = [".", nil, "P"]

    grid[left] not in falsey or
      grid[right] not in falsey or
      Enum.reduce(xs, false, fn ax, res -> grid[{y - 1, ax}] not in falsey or res end) or
      Enum.reduce(xs, false, fn ax, res -> grid[{y + 1, ax}] not in falsey or res end)
  end

  def adjacent_numbers(grid, coords) do
    diags(coords)
    |> Enum.map(fn {y, x} = coord ->
      case grid[coord] do
        num when is_integer(num) -> num
        "P" -> [grid[{y, x - 1}], grid[{y, x - 2}]] |> Enum.filter(&is_integer/1) |> hd
        _ -> nil
      end
    end)
    |> Enum.filter(& &1)
    |> Enum.uniq()
  end

  def diags({y, x}) do
    [
      {y, x - 1},
      {y, x + 1},
      {y + 1, x},
      {y - 1, x},
      {y + 1, x - 1},
      {y - 1, x - 1},
      {y + 1, x + 1},
      {y - 1, x + 1}
    ]
  end

  def parse_line(<<first::binary-1, rest::binary>>) do
    case Integer.parse(first) do
      {num, ""} -> parse_line(rest, [num])
      :error -> parse_line(rest, [first])
    end
  end

  def parse_line("", list), do: Enum.reverse(list)

  def parse_line(<<first::binary-1, rest::binary>>, [head | tail] = list) when is_integer(head) do
    # IO.inspect(list, label: "inside integer head")
    case Integer.parse(first) do
      {num, ""} ->
        parse_line(rest, [num + 10 * head | tail])

      :error ->
        # gives me 2 padding for 241 and 1 padding for 34
        padding = List.duplicate("P", magnitude(head) - 1)
        parse_line(rest, [first | padding] ++ list)
    end
  end

  def parse_line(<<first::binary-1, rest::binary>>, [head | _tail] = list) when is_binary(head) do
    # IO.inspect(list, label: "inside binary head")
    result =
      case Integer.parse(first) do
        {num, ""} -> num
        :error -> first
      end

    parse_line(rest, [result | list])
  end

  def magnitude(num), do: to_string(num) |> String.length()
end
