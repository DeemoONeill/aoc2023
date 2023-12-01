defmodule Day1Test do
  use ExUnit.Case

  test "gets 142" do
    assert 142 ==
             "inputs/day1_example.txt"
             |> File.stream!()
             |> Day1.calculate_calibration(Day1.digits())
  end

  test "gets 281" do
    assert 281 ==
             "inputs/day1_example2.txt"
             |> File.stream!()
             |> Day1.calculate_calibration(Day1.numbers())
  end

  test "dodgy" do
    assert 58 ==
             "five5nzlcdc45clclzrrkjthreeoneoneightsd\n"
             |> String.split()
             |> Day1.calculate_calibration(Day1.numbers())
  end
end
