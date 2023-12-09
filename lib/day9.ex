defmodule Day9 do
  def parse(lines) do
    lines |> Enum.map(&(String.split(&1) |> Enum.map(fn nums -> String.to_integer(nums) end)))
  end

  def main() do
    data = File.stream!("inputs/day9.txt") |> parse
    data |> part1 |> IO.inspect(label: "part 1")
    data |> part2 |> IO.inspect(label: "part 2")
  end

  defp sequence(list) do
    Enum.chunk_every(list, 2, 1, :discard) |> Enum.map(fn [first, second] -> first - second end)
  end

  def determine_sequence(line) do
    rev = line |> Enum.reverse()
    rev |> sequence |> determine_sequence([rev])
  end

  def determine_sequence(current, previous) do
    combined = [current | previous]

    if Enum.all?(current, &(&1 == 0)),
      do: combined,
      else: sequence(current) |> determine_sequence(combined)
  end

  def part1(lines) do
    lines
    |> Enum.map(&determine_sequence/1)
    |> Enum.map(fn sequence -> sequence |> Enum.map(&hd/1) |> Enum.sum() end)
    |> Enum.sum()
  end

  def part2(lines) do
    lines
    |> Enum.map(&determine_sequence/1)
    |> Enum.map(fn sequence ->
      sequence
      |> Enum.map(&List.last/1)
      |> Enum.reduce(fn current, previous -> current - previous end)
    end)
    |> Enum.sum()
  end
end
