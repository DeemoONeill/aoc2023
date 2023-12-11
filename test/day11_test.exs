defmodule Day11Test do
  use ExUnit.Case
  import Day11

  @example "...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#....."

  test "test explansion" do
    assert @example |> String.split() |> length == 10
    assert @example |> parse_grid |> length == 12
  end

  test "part 1 == 374" do
    assert @example |> parse_grid |> part1 == 374
  end

  test "part 2 == 1030 w/ 10x" do
    assert @example |> parse_massive(10) |> part2 == 1030
  end

  test "part 2 == 8410 w/ 100x" do
    assert @example |> parse_massive(100) |> part2 == 8410
  end
end
