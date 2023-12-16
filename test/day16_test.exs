defmodule Day16Test do
  use ExUnit.Case
  import Day16

  @example File.read!("inputs/day16_example.txt") |> parse

  test "assert part1 == 46" do
    assert @example |> part1 == 46
  end

  test "assert part2 == 51" do
    assert @example |> part2 == 51
  end
end
