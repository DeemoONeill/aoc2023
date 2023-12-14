defmodule Day14 do
  # defstruct

  def parse(lines) do
    lines
    |> String.split()
    |> Enum.map(fn row -> String.graphemes(row) end)
  end

  def main() do
    grid = File.read!("inputs/day14.txt") |> parse

    grid |> part1 |> IO.inspect(label: "part 1")
  end

  def transpose(rows) do
    rows |>  Enum.zip() |> Enum.map(&Tuple.to_list/1)
  end

  def part1(grid) do
    grid |> transpose
    |> Enum.map( &sort(&1))
    |> Enum.map( fn column -> size = length(column)
        column |> Enum.with_index |> Enum.map(
          fn {"O", idx} -> idx + size
          _ -> 0
          end
        )
        |> Enum.sum
    end)
    |> Enum.sum
  end

  def part2(_data) do
  end

  def sort(current), do: sort(current, [])
  def sort(current, current), do: current
  def sort(current, previous) do
    sort(sort_boulder(current, []), current)
  end

  def sort_boulder(current, previous)

  def sort_boulder([], previous), do: Enum.reverse(previous)
  def sort_boulder([".", "O" | rest], previous) do
    sort_boulder(["." | rest], ["O" | previous])
  end
  def sort_boulder([head | rest], previous) do
    sort_boulder(rest, [head | previous])
  end


end
