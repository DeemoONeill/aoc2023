defmodule Day1 do
  @digits ~r"\d"

  def digits(), do: @digits

  @spelled_out ~r"(?=(\d|one|two|three|four|five|six|seven|eight|nine))"

  def numbers(), do: @spelled_out

  @mapping ~W[one two three four five six seven eight nine]
           |> Enum.zip(Enum.map(1..9, &to_string/1))
           |> Map.new()

  def main() do
    lines =
      File.read!("inputs/day1.txt")
      |> String.split()

    lines
    |> calculate_calibration(@digits)
    |> IO.inspect(label: "part 1")

    lines
    |> calculate_calibration(@spelled_out)
    |> IO.inspect(label: "part 2")
  end

  def calculate_calibration(lines, regex) do
    lines
    |> Stream.map(&Regex.scan(regex, &1))
    |> Stream.map(&extract/1)
    |> Enum.sum()
  end

  defp extract(list) do
    first = List.first(list) |> Enum.join()

    last = List.last(list) |> Enum.join()

    (Map.get(@mapping, first, first) <> Map.get(@mapping, last, last))
    |> String.to_integer()
  end
end
