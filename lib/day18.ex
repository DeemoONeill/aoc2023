defmodule Day18 do
  defstruct direction: :dir, amount: 0, colour: "hex_string"

  def new(line) do
    [direction, number, hex] = line |> String.split()

    %Day18{
      direction: direction,
      amount: String.to_integer(number),
      colour: String.trim(hex, "(") |> String.trim(")")
    }
  end
  def new2(line) do
    [_direction, _number, hex] = line |> String.split()
    hex = String.trim(hex, "(#") |> String.trim(")")
    <<num::binary-size(byte_size(hex) -1), last::binary>> = hex

    direction = case last do
      "0" -> "R"
      "1" -> "D"
      "2" -> "L"
      "3" -> "U"
    end


    %Day18{
      direction: direction,
      amount: String.to_integer(num, 16),
    }
  end

  def main() do
    lines = File.read!("inputs/day18.txt") |> String.split("\n", trim: true)

    lines |> Enum.map(&new/1) |> part1 |> IO.inspect(label: "part 1")
    lines |> Enum.map(&new2/1) |> part1 |> IO.inspect(label: "part 2")
  end

  def part1(instructions) do
    coords = instructions
    |> Enum.map(&to_coord/1)
    |> Enum.reduce([{0, 0}], fn {y1, x1}, [{y2, x2} | _] = coords ->

      [{y1 + y2, x1 + x2 } | coords]
    end)

    ((perimeter(coords) /2) +
     green(coords) + 1) |> round

  end

  def to_coord(%{direction: dir, amount: num}) do
    case dir do
      "U" -> {-num, 0}
      "D" -> {num, 0}
      "R" -> {0, num}
      "L" -> {0, -num}
    end
  end

  def perimeter(coords) do
    coords
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [{y1, x1}, {y2, x2}] -> :math.sqrt(:math.pow((x2 - x1), 2) + :math.pow((y2 - y1), 2)) end)
    |> Enum.sum()
    |> abs
  end

  @doc """
  Greens forumula for finding the area of an irregular polygon without
  splitting it into basic shapes.
  ref: https://math.blogoverflow.com/2014/06/04/greens-theorem-and-area-of-polygons/
  """
  def green(points_list) do
    points_list
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [{y1, x1}, {y2, x2}] -> ((x2 + x1) * (y2 - y1) / 2)  end)
    |> Enum.sum()
    |> abs
  end
end
