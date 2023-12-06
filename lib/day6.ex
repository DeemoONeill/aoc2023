defmodule Day6 do

  def parse(data, func \\ &parse_line/1) do
    [times, distances] = data |> String.split("\n", trim: true)

    [func.(times), func.(distances)]
  end

  defp parse_line(line) do
    line
    |> String.split()
    |> Enum.map(fn item ->
      case Integer.parse(item) do
        {num, _rest} -> num
        :error -> nil
      end
    end)
    |> Enum.filter(& &1)
  end

  def parse_single(line) do
    line
    |> String.split()
    |> tl
    |> Enum.join("")
    |> String.to_integer()
  end

  @spec main() :: any()
  def main() do
    data = File.read!("inputs/day6.txt")

    data |> parse |> part1 |> IO.inspect(label: "part 1")

    data |> parse(&parse_single/1) |> part2 |> IO.inspect(label: "part 2")
  end

  def part1(races) do
    races
    |> Enum.zip()
    |> Enum.map(&ways_of_winning/1)
    |> Enum.product()
  end

  def ways_of_winning({time, distance}) do
    [2..(time - 2), (time - 2)..2]
    |> Stream.zip()
    |> Enum.reduce(0, fn {time_held, time_left}, acc ->
      if time_held * time_left > distance do
        acc + 1
      else
        acc
      end
    end)
  end

  def part2([time, distance]) do
    ways_of_winning({time, distance})
  end
end
