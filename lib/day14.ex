defmodule Day14 do
  def parse(lines) do
    lines |> String.split() |> Enum.map(fn row -> String.graphemes(row) end)
  end

  def main() do
    grid = File.read!("inputs/day14.txt") |> parse
    grid |> part1 |> IO.inspect(label: "part 1")
    grid |> part2 |> IO.inspect(label: "part 2")
  end

  def part1(grid) do
    grid |> transpose |> Enum.map(&sort/1) |> calculate_load
  end

  def part2(grid, cycles \\ 1_000_000) do
    Stream.cycle([0])
    |> Enum.reduce_while({0, grid, %{}}, fn _, {count, state, seen} ->
      new_state = cycle(state)

      if length(Map.get(seen, new_state, [])) > 4 do
        {:halt, seen}
      else
        {:cont, {count + 1, new_state, Map.update(seen, new_state, [count], &[count | &1])}}
      end
    end)
    |> Stream.filter(fn {_state, seen} -> length(seen) > 1 end)
    |> Stream.map(fn {state, seen} -> {state, hd(seen), differences(seen)} end)
    |> Stream.map(fn {state, head, [diff | _]} ->
      if is_cycle_state?(cycles - 1, head, diff), do: state
    end)
    |> Enum.filter(& &1)
    |> hd
    |> transpose
    |> calculate_load
  end

  def differences(seen) do
    Enum.chunk_every(seen, 2, 1, :discard)
    |> Enum.map(fn [first, second] -> first - second end)
  end

  def is_cycle_state?(cycles, head, diff),
    do: (cycles - head) / diff == div(cycles - head, diff)

  def calculate_load(grid) do
    grid
    |> Enum.map(fn row ->
      len = length(row)

      row
      |> Stream.with_index()
      |> Enum.map(fn
        {"O", idx} -> len - idx
        {_item, _idx} -> 0
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  def transpose(rows) do
    rows |> Stream.zip() |> Stream.map(&Tuple.to_list/1)
  end

  def cycle(grid) do
    grid
    # north
    |> transpose()
    |> Stream.map(&sort/1)
    # west
    |> transpose()
    |> Stream.map(&sort/1)
    # south
    |> transpose()
    |> Stream.map(&(sort(Enum.reverse(&1)) |> Enum.reverse()))
    # east
    |> transpose
    |> Enum.map(&(sort(Enum.reverse(&1)) |> Enum.reverse()))
  end

  def sort(current), do: sort(current, [])
  def sort(current, current), do: current

  def sort(current, _) do
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
