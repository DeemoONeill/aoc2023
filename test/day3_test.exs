defmodule Day3Test do
  use ExUnit.Case

  @example """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """

  test "numbers adjacent to symbol sum to 4361" do
    assert @example |> Day3.build_grid() |> Day3.part1() == 4361
  end

  test "two numbers adjacent to * sum to 467835" do
    assert @example |> Day3.build_grid() |> Day3.part2() == 467_835
  end
end
