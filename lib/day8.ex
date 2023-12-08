defmodule Day8 do
  def parse(lines) do
    [directions, nodes] = lines |> String.split("\n\n", trim: true)

    [
      Stream.cycle(directions |> String.graphemes()),
      nodes |> String.split("\n", trim: true) |> Enum.map(&parse_line/1) |> Map.new()
    ]
  end

  def parse_line(line) do
    ~r/(\w+)/ |> Regex.scan(line) |> Enum.map(fn [head | _] -> head end) |> parse_node
  end

  def parse_node([start, left, right]), do: {start, {left, right}}

  def main() do
    data = File.read!("inputs/day8.txt") |> parse

    data
    |> part1
    |> IO.inspect(label: "part 1")

    data
    |> part2
    |> IO.inspect(label: "part 2")
  end

  defp reducer(_, {steps, <<_::utf8, _::utf8, ?Z::utf8>>}, _nodes), do: {:halt, steps}

  defp reducer("L", {steps, current_node}, nodes),
    do: {:cont, {steps + 1, nodes[current_node] |> elem(0)}}

  defp reducer("R", {steps, current_node}, nodes),
    do: {:cont, {steps + 1, nodes[current_node] |> elem(1)}}

  def part1([directions, nodes]) do
    directions
    |> Enum.reduce_while({0, "AAA"}, &reducer(&1, &2, nodes))
  end

  def part2([directions, nodes]) do
    nodes
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "A"))
    |> Enum.map(fn node -> directions |> Enum.reduce_while({0, node}, &reducer(&1, &2, nodes)) end)
    |> Enum.reduce(&lcm/2)
  end

  def gcd(a, 0), do: abs(a)
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(a, b), do: div(abs(a * b), gcd(a, b))
end
