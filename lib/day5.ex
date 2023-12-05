defmodule Day5 do
  # defstruct
  def parse_maps(data) do
    [seeds | maps] = data |> String.split("\n\n")

    seeds =
      seeds
      |> String.split()
      |> Enum.map(fn
        <<"seed"::binary, _::binary>> -> nil
        <<"map"::binary, _::binary>> -> nil
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
    |> IO.inspect(label: "part 2")
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
    seed_ranges =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, contains] ->
        start..(start + contains - 1)
      end)

    1..77_435_467
    |> Stream.map(fn location ->
      seed =
        location
        |> rev_mapping(map["humidity-to-location"])
        |> rev_mapping(map["temperature-to-humidity"])
        |> rev_mapping(map["light-to-temperature"])
        |> rev_mapping(map["water-to-light"])
        |> rev_mapping(map["fertilizer-to-water"])
        |> rev_mapping(map["soil-to-fertilizer"])
        |> rev_mapping(map["seed-to-soil"])

      present = seed_ranges |> Enum.any?(fn range -> seed in range end)
      {present, location}
    end)
    |> Enum.reduce_while(0, fn
      {false, _}, _ -> {:cont, 0}
      {true, location}, _ -> {:halt, location}
    end)
  end

  # destination, source, num, difference
  # 50..50+num
  def rev_mapping(seed, []), do: seed

  def rev_mapping(seed, [[destination, source, num] | tl]) do
    IO.inspect({seed, destination, source})
    case seed do
      seed when seed in destination..(destination + (num - 1)) -> seed + (source - destination)
      seed -> mapping(seed, tl)
    end
  end

  def mapping(seed, []), do: seed

  def mapping(seed, [[destination, source, num] | tl]) do
    case seed do
      seed when seed in source..(source + (num - 1)) -> seed + destination - source
      seed -> mapping(seed, tl)
    end
  end
end
