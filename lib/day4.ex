defmodule Day4 do
  defstruct card: 0, winning: %{}, seen: %{}

  def new(line) do
    [card, numbers] = line |> String.trim() |> String.split(":")
    [winning, seen] = numbers |> String.split("|")

    %Day4{
      card: card |> String.trim_leading("Card ") |> String.trim() |> String.to_integer(),
      winning: winning |> parse_to_set(),
      seen: seen |> parse_to_set()
    }
  end

  defp parse_to_set(nums) do
    nums
    |> String.split(" ", trim: true)
    |> Enum.map(&(&1 |> String.trim() |> String.to_integer()))
    |> MapSet.new()
  end

  def main() do
    scratchcards =
      File.read!("inputs/day4.txt")
      |> String.split("\n", trim: true)
      |> Enum.map(&new/1)
      |> Enum.map(&number_of_winners/1)

    scratchcards
    |> part1
    |> IO.inspect(label: "part 1")

    scratchcards
    |> part2
    |> IO.inspect(label: "part 2")
  end

  def part1(winners) do
    winners
    |> Enum.filter(&(&1 != 0))
    |> Enum.map(&(:math.pow(2, &1 - 1) |> round))
    |> Enum.sum()
  end

  def part2(winners) do
    {_, total} =
      winners
      |> Enum.with_index(1)
      |> Enum.reduce({%{}, 0}, fn {won, idx}, {map, current_total} ->
        copies = Map.get(map, idx, 0) + 1

        additions =
          unless won == 0 do
            Enum.zip((idx + 1)..(idx + won), List.duplicate(copies, won))
            |> Map.new()
          else
            %{}
          end

        {Map.merge(additions, map, fn _, val1, val2 -> val1 + val2 end), current_total + copies}
      end)
      total
  end

  def number_of_winners(%Day4{winning: winning, seen: seen}) do
    MapSet.intersection(winning, seen) |> Enum.count()
  end
end
