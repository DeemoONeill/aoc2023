defmodule Day6 do
  def parse(data, func \\ &parse_line/1) do
    [times, distances] = data |> String.split("\n", trim: true)

    [func.(times), func.(distances)]
  end

  defp parse_line(line) do
    line
    |> String.split()
    |> Enum.map(fn item ->
      case Integer.parse(item) do
        {num, _rest} -> num
        :error -> nil
      end
    end)
    |> Enum.filter(& &1)
  end

  def parse_single(line) do
    line
    |> String.split()
    |> tl
    |> Enum.join("")
    |> String.to_integer()
  end

  @spec main() :: any()
  def main() do
    data = File.read!("inputs/day6.txt")

    data |> parse |> part1 |> IO.inspect(label: "part 1")

    data |> parse(&parse_single/1) |> part2 |> IO.inspect(label: "part 2")
  end

  def part1(races) do
    races
    |> Enum.zip()
    |> Enum.map(&ways_of_winning/1)
    |> Enum.product()
  end

  def part2([time, distance]) do
    ways_of_winning({time, distance})
  end

  def ways_of_winning({time, distance}) do
    {from, to} = quadratic(time, distance)

    start =
      from..to
      |> Enum.reduce_while(0, &reducer(&1, &2, time, distance))

    end_ =
      to..from
      |> Enum.reduce_while(0, &reducer(&1, &2, time, distance))

    1 + end_ - start
  end

  defp reducer(time_taken, _acc, time, distance) do
    if time_taken * (time - time_taken) > distance do
      {:halt, time_taken}
    else
      {:cont, 0}
    end
  end

  @doc """
  Formula for a winning race is

  x * (time-x) - distance > 0

  which rerranged is
  -x^2 + time*x - distance
  -1x^2 + time*x - distance

  solving the roots with quadratic formula gives where the curve intersects
  with the x axis. adding 1 to the larger root, and subtracting 1 from the smaller
  root means we don't have to worry about how elixir rounds the numbers
  we can then use these to check a handful and just get the difference between the two
  """
  def quadratic(time, distance) do
    a = -1
    b = time
    c = -distance
    bs = b * b

    positive = (-b + :math.sqrt(bs - 4 * a * c)) / (2 * a)
    negative = (-b - :math.sqrt(bs - 4 * a * c)) / (2 * a)

    {round(positive - 1), round(negative + 1)}
  end
end
