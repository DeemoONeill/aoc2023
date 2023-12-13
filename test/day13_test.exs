defmodule Day13Test do
  use ExUnit.Case
  import Day13
  @hexample "#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#"

  @vexample "#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#."
  @niller "..##.######.##.
######.##.#####
##..#.####.#..#
.#..##.##.##..#
#.....####.....
#..............
#....##..##....
.####......####
..#..#.##.#..#.
#.##........##.
.....#....#...."
 @niller2 "...####.....#
####..####...
#..#..#..#..#
#..#..#..###.
....##......#
.##.##.##...#
.##.##.##.#..
....##....##.
####..#####.#
.##.##.##.#..
#..#..#..###."

  test "horizontal example returns 4" do
    assert @hexample |> String.split() |> check_entries(1, []) == 4
  end

  test "vertical example returns false as rows" do
    assert @vexample |> String.split() |> check_entries(1, []) == nil
  end

  test "vertical example returns 5 as columns" do
    assert @vexample
           |> String.split()
           |> Enum.map(&String.graphemes/1)
           |> Enum.zip()
           |> Enum.map(&Tuple.to_list/1)
           |> check_entries(1, []) == 5
  end

  test "vertical example has smudged reflection at 1" do
    assert @vexample |> check_smudges == 300
  end
  test "horizontal example has smudged reflection at 3" do
    assert @hexample |> check_smudges == 100
  end

  test "niller == 8 in vertical" do
    assert @niller |> check_entry == 8
  end

  test "niller 2 == 5" do
    assert @niller2 |>  check_entry == 5
  end

  test "example 3 == 600" do
  assert "####.##...#..
.#.....##.#.#
....#.#....#.
..#..#..###..
....####..###
..####..##...
..####..##..."  |> check_entry == 600
  end

  test "example 4 == nil" do
  assert ".#..#..#.###.##
....#...##...##
#....##.#...###
#.##.#...#.#.##
#.##.#..#...###
#.##.#.....####
.#..#...#.#.###
..##...##.###..
#.##.##.#...#..
#....###...##..
.........####..
#######.##.#.##
##..###.#...#.." |> check_entry == 14
  end


end
