defmodule Day1Test do
  use ExUnit.Case

  test "gets 142" do
    assert "inputs/day1_example.txt" |> File.stream!() |> Day1.part1() == 142
  end

  test "gets 281" do
    assert "inputs/day1_example2.txt" |> File.stream!() |> Day1.part2() == 281
  end

  test "dodgy" do
    assert "five5nzlcdc45clclzrrkjthreeoneoneightsd\n" |> String.split() |> Day1.part2() == 58
  end
end
