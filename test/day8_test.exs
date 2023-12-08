defmodule Day8Test do
  use ExUnit.Case
  import Day8

  @example1 "RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ"

  @example2 "LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)"

  @example3 "LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)"

  test "test part1 examples" do
    assert @example1 |> parse |> part1 == 2
    assert @example2 |> parse |> part1 == 6
  end

  test "part 2 examples" do
    assert @example3 |> parse |> part2 == 6
  end
end
