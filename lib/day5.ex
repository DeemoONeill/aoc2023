defmodule Day5 do
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
      |> Enum.reduce(&Map.merge/2)

    {seeds, map}
  end

  def parse_mappings(line) do
    line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
  end

  def main() do
    {seeds, map} = File.read!("inputs/day5.txt") |> parse_maps

    start = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    part1(seeds, map)
    |> IO.inspect(label: "part 1")

    # hunch that it's not less than 10 mn
    part2(seeds, map)
    |> IO.inspect(label: "part 2")
    end_time = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    IO.inspect(end_time - start, label: "time taken (ms)")
  end

  def part1(seeds, map) when is_map(map) do
    seeds
    |> Stream.map(fn seed ->
      seed
      |> mapping(map["seed-to-soil"])
      |> mapping(map["soil-to-fertilizer"])
      |> mapping(map["fertilizer-to-water"])
      |> mapping(map["water-to-light"])
      |> mapping(map["light-to-temperature"])
      |> mapping(map["temperature-to-humidity"])
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

    # approximate the amount by skipping parts of the ranges and calulate this in parallel
    approx =
      seed_ranges
      |> Enum.map(fn range ->
        broad_range = Range.new(range.first, range.last, div(Range.size(range), 100)+1)
        Task.async(fn -> part1(broad_range, map) end)
      end)
      |> Task.await_many()
      |> Enum.min()

    (approx*0.979 |> round)..(approx)
    |> Stream.map(&calculate_location(&1, map, seed_ranges))
    |> Enum.reduce_while(0, fn
      {false, _}, _ -> {:cont, 0}
      {true, location}, _ -> {:halt, location}
    end)
  end

  def calculate_location(location, map, seed_ranges) do
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
  end

  def rev_mapping(seed, []), do: seed

  def rev_mapping(seed, [[source, destination, num] | tl]) do
    case seed do
      seed when seed in source..(source + (num - 1)) -> seed + destination - source
      seed -> rev_mapping(seed, tl)
    end
  end

  def mapping(seed, []), do: seed

  def mapping(seed, [[destination, source, num] | tl]) do
    case seed do
      seed when seed in source..(source + (num - 1)) -> seed + (destination - source)
      seed -> mapping(seed, tl)
    end
  end
end
