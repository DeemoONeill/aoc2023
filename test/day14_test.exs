defmodule Day14Test do
  use ExUnit.Case
  import Day14

  @example "O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#...."

  @result "OOOO.#.O..
OO..#....#
OO..O##..O
O..#.OO...
........#.
..#....#.#
..O..#.O.O
..O.......
#....###..
#....#...." |> String.split |> Enum.map(&String.graphemes/1) |> transpose

  test "number of items in example map == 35" do
    assert @example |> parse |> part1 == 136
  end

  test "sorted example == result" do
    assert @example |> parse |> transpose |> sort == @result
  end

end
