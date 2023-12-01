defmodule Day1 do
  def part1(lines) do
    lines
    |> Enum.map(&match_digits/1)
    |> Enum.map(&extract/1)
    |> Enum.sum()
  end

  def part2(lines) do
    mapping =
      ~W[one two three four five six seven eight nine]
      |> Enum.zip(Enum.map(1..9, &to_string/1))
      |> Map.new()

    lines
    |> Stream.map(&match_numbers/1)
    |> Stream.map(&extract(&1, mapping))
    |> Enum.sum()
  end

  defp match_numbers(line) do
    first =
      ~r"\d|one|two|three|four|five|six|seven|eight|nine"
      |> Regex.run(line)

    last =
      ~r"\d|eno|enin|thgie|neves|xis|evif|ruof|eerht|owt"
      |> Regex.run(String.reverse(line))
      |> Enum.map(&String.reverse/1)

    [first, last]
  end

  defp match_digits(line) do
    ~r"\d"
    |> Regex.scan(line)
  end

  defp extract(list) do
    ((List.first(list) |> hd) <> (List.last(list) |> hd))
    |> String.to_integer()
  end

  defp extract(list, mapping) do
    first = List.first(list) |> hd
    last = List.last(list) |> hd

    (Map.get(mapping, first, first) <> Map.get(mapping, last, last))
    |> String.to_integer()
  end
end
