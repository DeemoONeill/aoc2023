defmodule Day14Test do
  use ExUnit.Case
  import Day14

  @example "O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#...."

  @result "OOOO.#.O..
OO..#....#
OO..O##..O
O..#.OO...
........#.
..#....#.#
..O..#.O.O
..O.......
#....###..
#....#...." |> String.split() |> Enum.map(&String.graphemes/1)

  @cycle1 ".....#....
....#...O#
...OO##...
.OO#......
.....OOO#.
.O#...O#.#
....O#....
......OOOO
#...O###..
#..OO#...." |> String.split() |> Enum.map(&String.graphemes/1)

  @cycle2 ".....#....
....#...O#
.....##...
..O#......
.....OOO#.
.O#...O#.#
....O#...O
.......OOO
#..OO###..
#.OOO#...O" |> String.split() |> Enum.map(&String.graphemes/1)

  @cycle3 ".....#....
....#...O#
.....##...
..O#......
.....OOO#.
.O#...O#.#
....O#...O
.......OOO
#...O###.O
#.OOO#...O" |> String.split() |> Enum.map(&String.graphemes/1)

  test "number of items in example map == 35" do
    assert @example |> parse |> part1 == 136
  end

  test "sorted example == result" do
    assert @example |> parse |> transpose |> Enum.map(&sort/1) == @result |> transpose |> Enum.to_list
  end

  test "sort_boulder" do
    assert ~w[. O] |> sort_boulder([]) == ~w[O .]
    assert ~w[# O] |> sort_boulder([]) == ~w[# O]
    assert ~w[. O . O] |> sort_boulder([]) == ~w[O . O .]
    assert ~w[. O # O] |> sort_boulder([]) == ~w[O . # O]
  end

  test "sort" do
    assert ~w[. O] |> sort() == ~w[O .]
    assert ~w[# O] |> sort() == ~w[# O]
    assert ~w[. O . O] |> sort() == ~w[O O . .]
    assert ~w[. O # O . . O . O] |> sort([]) == ~w[O . # O O O . . .]
  end

  test "cycle" do
    assert @example |> parse |> cycle == @cycle1
    assert @example |> parse |> cycle |> cycle == @cycle2
    assert @example |> parse |> cycle |> cycle |> cycle == @cycle3
  end

  test "part2 == 64" do
    assert @example |> parse |> part2 == 63
  end
end
