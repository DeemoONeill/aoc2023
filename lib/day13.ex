defmodule Day13 do
  # defstruct

  def main() do
    data =
      File.read!("inputs/day13.txt")
      |> String.split("\n\n", trim: true)

    data
    |> part1
    |> IO.inspect(label: "part 1")
    data
    |> part2
    |> IO.inspect(label: "part 2")
  end

  def part1(floors) do
    floors
    |> Enum.map(&check_entry/1)
    |> Enum.sum
  end

  def part2(floors) do
    floors
    |> Enum.map(&check_smudges/1)
    |> Enum.sum
    # not 38076
  end

  def check_smudges(entry) do
    entry = entry |> String.split() |> Enum.map(&String.graphemes/1)
    case check_entries(entry, 1, [], false) do
      num when is_integer(num) -> num * 100
      nil ->
        entry |> Enum.zip() |> Enum.map(&Tuple.to_list/1)  |> check_entries(1, [], false)
    end
  end

  def differences(first, second) do
    Enum.zip(first, second) |> Enum.reduce(0, fn {a, a}, acc -> acc
    {a, b}, acc -> acc + 1
  end)
  end

  def check_entries(entry, count, previous, fixed?)
  def check_entries([_first | []], _, _, _), do: nil
  def check_entries([first , first | rest ], count, previous, false) do
    if smudged_reflection_found?(rest, previous) do
      count
    else
      check_entries([first | rest], count+1 , [first | previous], false)
    end
  end
  def check_entries([first, second | rest], count, previous, false) do
    if differences(first, second) == 1 and reflection_found?(rest, previous) do
      count

    else
      check_entries([second | rest], count+1 , [first | previous], false)
    end
  end

  def smudged_reflection_found?([first | tail1], [first | tail2]) do
    smudged_reflection_found?(tail1, tail2)
  end

  def smudged_reflection_found?([first | tail1], [second | tail2]) do
    if differences(first, second) == 1 do
      reflection_found?(tail1, tail2)
    else
      false
    end
  end
  def smudged_reflection_found?([], _), do: true
  def smudged_reflection_found?(_, []), do: true

  def check_entry(entry) do
    entry = entry |> String.split() |> Enum.map(&String.graphemes/1)
    case check_entries(entry, 1, []) do
      nil ->
        entry |> Enum.zip() |> Enum.map(&Tuple.to_list/1)  |> check_entries(1, [])
      num when is_integer(num) -> num * 100
    end
  end

  def reflection_found?([], _), do: true
  def reflection_found?(_, []), do: true

  def reflection_found?([head | tail1], [head | tail2]) do
    reflection_found?(tail1, tail2)
  end

  def reflection_found?([_head1 | _], [_head2 | _]), do: false

  def check_entries(rows, count, previous)

  def check_entries([_first | []], _count, _), do: nil
  def check_entries([first, first | rest], count, previous) do
    if reflection_found?(rest, previous) do
      count
    else
      check_entries([first | rest], count+1 , [first | previous])
    end
  end

  def check_entries([first, second | rest], count, previous) do
    check_entries([second | rest], count + 1, [first | previous])
  end

end
