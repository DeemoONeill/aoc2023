defmodule Day10Test do
  use ExUnit.Case
  import Day10

  @example1 ".....
  .S-7.
  .|.|.
  .L-J.
  ....."

  @example2 "..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ..."

  test "parses into a map" do
    assert @example1 |> parse |> is_map()
  end

  test "finds start position" do
    assert @example1 |> parse |> start == {{1, 1}, "S"}
  end

  test "part1 example 1 == 4 " do
    map = @example1 |> parse
    starting = map |> start

    assert map |> part1(starting) == 4
  end

  test "part1 example 2 == 8 " do
    map = @example2 |> parse
    starting = map |> start

    assert map |> part1(starting) == 8
  end

  test "green" do
    assert 12 ==
             [
               {0, 0},
               {1.5, 0},
               {2.5, -1},
               {3.5, 0},
               {5, 0},
               {5, 2},
               {3.5, 2},
               {2.5, 3},
               {1.5, 2},
               {0, 2},
               {0, 2}
             ]
             |> Enum.map(fn {x, y} -> {y, x} end)
             |> green
  end
end
