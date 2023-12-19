defmodule Day18 do
  defstruct direction: :dir, amount: 0, colour: "hex_string"

  def new(line) do
    [direction, number, hex] = line |> String.split()

    %Day18{
      direction: direction,
      amount: String.to_integer(number),
      colour: String.trim(hex, "(#") |> String.trim(")")
    }
  end

  def main() do
    lines = File.read!("inputs/day18.txt") |> String.split("\n", trim: true) |> Enum.map(&new/1)

    lines |> part1 |> IO.inspect(label: "part 1")
    lines |> part1(&to_coord2/1) |> IO.inspect(label: "part 2")
  end

  def part1(instructions, coord_func \\ &to_coord/1) do
    coords =
      instructions
      |> Enum.map(&coord_func.(&1))
      |> Enum.reduce([{0, 0}], fn {y1, x1}, [{y2, x2} | _] = coords ->
        [{y1 + y2, x1 + x2} | coords]
      end)

    (perimeter(coords) / 2 + Day10.green(coords) + 1) |> round
  end

  def to_coord2(%{colour: colour}) do
    <<num::binary-size(byte_size(colour) - 1), dir::binary>> = colour
    num = String.to_integer(num, 16)

    case dir do
      # R
      "0" -> {0, num}
      # "D"
      "1" -> {num, 0}
      # "L"
      "2" -> {0, -num}
      # "U"
      "3" -> {-num, 0}
    end
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
    |> Stream.map(fn [{y1, x1}, {y2, x2}] ->
      :math.sqrt(:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2))
    end)
    |> Enum.sum()
    |> abs
  end
end
