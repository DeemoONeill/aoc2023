defmodule Day5 do
  # defstruct
  def parse_maps(data) do
    [seeds | maps] = data |> String.split("\n\n")

    seeds =
      seeds
      |> String.split()
      |> Enum.map(fn
        <<"seed"::binary, _::binary>> -> nil
        num -> String.to_integer(num)
      end)
      |> Enum.filter(& &1)

    map =
      maps
      |> Enum.map(fn map ->
        [map_name | mappings] = map |> String.split("\n", trim: true)
        name = map_name |> String.trim() |> String.trim_trailing(" map:")

        %{name => mappings |> Enum.map(&parse_mappings/1)}
      end)
      |> Enum.reduce(%{}, &Map.merge/2)

    {seeds, map}
  end

  def parse_mappings(line) do
    line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def main() do
    {seeds, map} = File.read!("inputs/day5.txt") |> parse_maps

    part1(seeds, map)
    |> IO.inspect(label: "part 1")

    part2(seeds, map)
    |> IO.inspect(label: "part 1")
  end

  def part1(seeds, map) when is_map(map) do
    seeds
    |> Stream.map(fn seed ->
      seed
      # |>IO.inspect(label: "seed")
      |> mapping(map["seed-to-soil"])
      # |>IO.inspect(label: "soil")
      |> mapping(map["soil-to-fertilizer"])
      # |>IO.inspect(label: "fertilizer")
      |> mapping(map["fertilizer-to-water"])
      # |>IO.inspect(label: "water")
      |> mapping(map["water-to-light"])
      # |>IO.inspect(label: "light")
      |> mapping(map["light-to-temperature"])
      # |>IO.inspect(label: "temperature")
      |> mapping(map["temperature-to-humidity"])
      # |>IO.inspect(label: "humidity")
      |> mapping(map["humidity-to-location"])

    end)
    |> Enum.min()
  end

  def part2(seeds, map) do
    seeds
    |> Enum.chunk_every(2)
    |> Enum.map(fn chunk ->
      Task.async(fn ->
        [start, contains] = chunk
        start..(start + contains - 1)
        |> MapSet.new()
        |> part1(map)
      end)
    end)
    |> Task.await_many(:infinity)
    |> Enum.min
  end

  # destination, source, num, difference
  # 50..50+num-1, 98..98+num-1, 2, 50-98

  def mapping(seed, []), do: seed

  def mapping(seed, [[destination, source, num] | tl]) do
    case seed do
      seed when seed in source..(source + (num - 1)) -> seed + destination - source
      seed -> mapping(seed, tl)
    end
  end
end
