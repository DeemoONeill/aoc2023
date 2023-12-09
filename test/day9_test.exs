defmodule Day9Test do
  use ExUnit.Case
  import Day9

  @example "0 3 6 9 12 15\n" |> String.split("\n", trim: true) |> parse

  @full_example "0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45" |> String.split("\n", trim: true) |> parse

  @part2_example "10 13 16 21 30 45" |> String.split("\n", trim: true) |> parse

  test "part1 gives 18 for first example" do
    assert @example |> part1 == 18
  end

  test "part1 gives 18 for full example" do
    assert @full_example |> part1 == 114
  end

  test "sequence determintion" do
    assert [0, 3, 6, 9, 12, 15] |> determine_sequence == [
             [0, 0, 0, 0],
             [3, 3, 3, 3, 3],
             [15, 12, 9, 6, 3, 0]
           ]
  end

  test "part2 first example" do
    assert @part2_example |> part2 == 5
  end

  test "part2 full example" do
    assert @full_example |> part2 == 2
  end
end
