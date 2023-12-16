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
    assert @example |> parse_massive(2) |> length == 9
  end

  test "part 1 == 374" do
    assert @example |> parse_massive(2) |> parts == 374
  end

  test "part 2 == 1030 w/ 10x" do
    assert @example |> parse_massive(10) |> parts == 1030
  end

  test "part 2 == 8410 w/ 100x" do
    assert @example |> parse_massive(100) |> parts == 8410
  end
end
