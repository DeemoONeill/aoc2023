defmodule Day6Test do
  use ExUnit.Case

  @example "Time:      7  15   30
  Distance:  9  40  200 "

  @parsed @example |> Day6.parse()

  test "parse_data" do
    assert @example |> Day6.parse() == [[7, 15, 30], [9, 40, 200]]
  end

  test "example for part 1 gives 288" do
    assert @parsed |> Day6.part1() == 288
  end

  test "example for part2 gives 71503" do
    assert @example |> Day6.parse(&Day6.parse_single/1) |> Day6.part2() == 71503
  end
end
