defmodule Day15Test do
  use ExUnit.Case
  import Day15

  @example "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"

  test "hash of HASH == 52" do
    assert "HASH" |> hash == 52
  end

  test "part1 == 1320" do
    assert @example |> String.split(",") |> part1 == 1320
  end

  test "part2 == 145" do
    assert @example |> String.split(",") |> part2 == 145
  end
end
