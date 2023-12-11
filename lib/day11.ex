defmodule Day11 do
  def rotate(list) do
    list
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def expand_universe(rows, jump) do
    rows
    |> Enum.map(fn line ->
      if Enum.all?(line, &(&1 == ".")) do
        {line, jump}
      else
        {line, 1}
      end
    end)
    |> Enum.reduce({0, []}, fn {row, current}, {previous, list} ->
      new_idx = previous + current
      {new_idx, list ++ [{row, new_idx}]}
    end)
    |> elem(1)
    |> Enum.reduce({[], []}, fn {row, idx}, {rows, idxs} ->
      {rows ++ [row], idxs ++ [idx]}
    end)
  end

  def parse_massive(lines, jump) do
    {rows, ys} =
      lines
      |> String.split()
      |> Enum.map(&String.graphemes/1)
      |> expand_universe(jump)

    xs = rows |> rotate() |> expand_universe(jump) |> elem(1)

    for {row, y} <- Enum.zip(rows, ys) do
      for {char, x} <- Enum.zip(row, xs), char == "#" do
        {y, x}
      end
    end
    |> List.flatten()
  end

  def main() do
    grid = File.read!("inputs/day11.txt")
    grid |> parse_massive(2) |> parts |> IO.inspect(label: "part 1")
    grid |> parse_massive(1_000_000) |> parts |> IO.inspect(label: "part 2")
  end

  def manhattan({y1, x1}, {y2, x2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def parts(galaxies) do
    galaxies
    |> Enum.reduce({0, galaxies}, fn
      current, {total, [_ | remaining]} ->
        {total + (remaining |> Enum.map(&manhattan(&1, current)) |> Enum.sum()), remaining}

      _current, acc ->
        acc
    end)
    |> elem(0)
  end
end
