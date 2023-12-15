defmodule Day15 do
  # defstruct

  def main() do
    strings = File.read!("inputs/day15.txt") |> String.trim() |> String.split(",", trim: true)

    part1(strings) |> IO.inspect(label: "part 1")
    part2(strings) |> IO.inspect(label: "part 2")
  end

  def part1(strings) do
    strings |> Enum.map(&hash/1) |> Enum.sum()
  end

  def part2(strings) do
    strings
    |> Enum.map(fn string ->
      split_char = if String.contains?(string, "-"), do: "-", else: "="
      {String.split(string, split_char) |> hd |> hash, string}
    end)
    |> Enum.reduce(%{}, fn {hash, string}, acc ->
      case String.split(string, "=") do
        [key, value] -> acc |> add_to_hashmap(hash, key, value)
        [minus] -> acc |> remove_from_hashmap(hash, minus)
      end
    end)
    |> Enum.filter(fn {key, list} -> length(list) > 0 end)
    |> Enum.sort()
    |> Enum.reduce(0, fn {box, lenses}, acc ->
      acc +
        (lenses
         |> Enum.with_index(1)
         |> Enum.map(fn {{_key, value}, idx} -> (box + 1) * value * idx end)
         |> Enum.sum())
    end)
  end

  def add_to_hashmap(map, hash, key, value) do
    key = String.to_atom(key)
    value = value |> String.to_integer()
    entry = {key, value}
    map |> Map.update(hash, [entry], &Keyword.update(&1, key, value, fn _ -> value end))
  end

  def remove_from_hashmap(map, hash, key) do
    key = key |> String.trim_trailing("-") |> String.to_atom()
    map |> Map.update(hash, [], &(&1 |> Keyword.pop(key) |> elem(1)))
  end

  def hash(string) do
    string
    |> String.to_charlist()
    |> Enum.reduce(0, fn char, acc ->
      rem((char + acc) * 17, 256)
    end)
  end
end
