defmodule Day7 do
  # 5oac 7, 4oac 6, fh 5, 3oac 4, 2p 3, 1p 2, hc 1
  defstruct cards: [], bid: 0, hand: 0

  def new(hand) do
    [cards, bid] = hand |> String.split()
    cards = cards |> String.graphemes() |> Enum.map(&card_values(&1))

    hand_num =
      cards
      |> Enum.reduce(%{}, fn card, map ->
        Map.update(map, card, 1, fn existing -> existing + 1 end)
      end)
      |> Map.values()
      |> Enum.sort(:desc)
      |> hand_value

    %Day7{cards: cards, bid: bid |> String.to_integer(), hand: hand_num}
  end

  def card_values(card, j_value \\ 11) do
    case {card, Integer.parse(card)} do
      {"A", _} -> 14
      {"K", _} -> 13
      {"Q", _} -> 12
      {"J", _} -> j_value
      {"T", _} -> 10
      {_, {num, _}} -> num
    end
  end

  def new2(hand) do
    [cards, bid] = hand |> String.split()
    cards = cards |> String.graphemes() |> Enum.map(&card_values(&1, 1))

    {hand_num, jokers} =
      cards
      |> Enum.reduce({%{}, 0}, fn
        1, {map, jokers} ->
          {map, jokers + 1}

        card, {map, jokers} ->
          {Map.update(map, card, 1, fn existing -> existing + 1 end), jokers}
      end)

    values =
      hand_num
      |> Map.values()
      |> Enum.sort(:desc)

    top =
      unless values == [] do
        jokers + (values |> hd)
      else
        jokers
      end

    tail =
      unless values == [] do
        values |> tl
      else
        []
      end

    hand_num = [top | tail] |> hand_value

    %Day7{cards: cards, bid: bid |> String.to_integer(), hand: hand_num}
  end

  def hand_value(nums) do
    case nums do
      [5] -> 7
      [4, 1] -> 6
      [3, 2] -> 5
      [3, 1, 1] -> 4
      [2, 2, 1] -> 3
      [2, 1, 1, 1] -> 2
      [1, 1, 1, 1, 1] -> 1
    end
  end

  def main() do
    hands = File.read!("inputs/day7.txt") |> String.split("\n", trim: true)

    hands |> Enum.map(&new/1) |> part1 |> IO.inspect(label: "part 1")
    hands |> Enum.map(&new2/1) |> part1 |> IO.inspect(label: "part 2")
  end

  def part1(hands) do
    hands
    |> Enum.sort_by(&{&1.hand, &1.cards})
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {card, index}, acc -> acc + card.bid * index end)
  end
end
