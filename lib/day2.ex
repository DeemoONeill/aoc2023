defmodule Day2 do
  defstruct game: 0, rounds: %{}

  @doc """
  Parsing logic getting it into a struct
  """
  def new(round) do
    [game, rounds] = round |> String.split(":", trim: true)

    game_number = game |> String.trim_leading("Game ") |> String.to_integer()

    rounds_map =
      rounds
      |> String.split(";")
      |> Enum.map(fn rows -> String.split(rows, ",") |> Map.new(&split_rounds/1) end)
      |> Enum.reduce(
        %{red: 0, green: 0, blue: 0},
        fn map, acc ->
          Map.merge(acc, map, fn
            _, val1, val2 when val1 >= val2 -> val1
            _, val1, val2 when val2 > val1 -> val2
          end)
        end
      )

    %Day2{game: game_number, rounds: rounds_map}
  end

  defp split_rounds(string) do
    {number, colour} = string |> String.trim() |> Integer.parse()
    {String.trim(colour) |> String.to_atom(), number}
  end

  def main() do
    games = File.read!("inputs/day2.txt") |> String.split("\n", trim: true) |> Enum.map(&new/1)

    games |> part1 |> IO.inspect(label: "Part 1")
    games |> part2 |> IO.inspect(label: "Part 2")
  end

  def part1(games) do
    games
    |> Enum.filter(&round_possible?/1)
    |> Enum.reduce(0, fn struct, acc -> struct.game + acc end)
  end

  def part2(games) do
    games
    |> Enum.map(fn %Day2{rounds: rounds} -> rounds |> Map.values() |> Enum.product() end)
    |> Enum.sum()
  end

  defp round_possible?(%Day2{rounds: %{red: red, green: green, blue: blue}}) do
    red <= 12 and green <= 13 and blue <= 14
  end
end
