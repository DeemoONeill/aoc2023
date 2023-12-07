defmodule Day7Test do
  use ExUnit.Case

  @example "32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483"

  @parsed @example |> String.split("\n", trim: true) |> Enum.map(&Day7.new/1)

  test "test card parsing" do
    assert @example |> String.split("\n", trim: true) |> hd |> Day7.new() == %Day7{
             cards: [3, 2, 10, 3, 13],
             bid: 765,
             hand: 2
           }
  end

  test "part1 == 6440" do
    assert @parsed |> Day7.part1() == 6440
  end
end
