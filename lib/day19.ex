defmodule Day19 do
  defstruct x: 0, m: 0, a: 0, s: 0

  def new(line) do
    [x, m, a, s] =
      ~r"x=(\d+),m=(\d+),a=(\d+),s=(\d+)"
      |> Regex.scan(line)
      |> hd
      |> tl
      |> Enum.map(&String.to_integer/1)

    %Day19{x: x, m: m, a: a, s: s}
  end

  def parse_workflows(workflow) do
    [name, conditions] = workflow |> String.trim("}") |> String.split("{")

    functions =
      conditions
      |> String.split(",")
      |> Enum.map(fn
        <<key::binary-1, "<", num_loc::binary>> ->
          [num, loc] = String.split(num_loc, ":")
          num = String.to_integer(num)
          fn struct -> if Map.get(struct, String.to_atom(key)) < num, do: loc end

        <<key::binary-1, ">", num_loc::binary>> ->
          [num, loc] = String.split(num_loc, ":")
          num = String.to_integer(num)
          fn struct -> if Map.get(struct, String.to_atom(key)) > num, do: loc end

        loc ->
          fn _struct -> loc end
      end)

    {name, functions}
  end

  def parse_workflows(workflow, :no_func) do
    [name, conditions] = workflow |> String.trim("}") |> String.split("{")

    functions =
      conditions
      |> String.split(",")
      |> Enum.map(fn
        <<key::binary-1, comparison::binary-1, num_loc::binary>> when comparison in ["<", ">"] ->
          [num, loc] = String.split(num_loc, ":")
          {String.to_atom(key), comparison, String.to_integer(num), loc}

        loc ->
          loc
      end)

    {name, functions}
  end

  def parse(lines) do
    [workflows, parts] = lines |> String.split("\n\n")

    parts = parts |> String.split() |> Enum.map(&new/1)

    workflows = workflows |> String.split() |> Enum.map(&parse_workflows/1) |> Map.new()

    {workflows, parts}
  end

  def main() do
    input = File.read!("inputs/day19.txt")
    {workflows, parts} = input |> parse

    part1(workflows, parts)
    |> IO.inspect(label: "part 1")

    input
    |> part2
    |> IO.inspect(label: "part 2")
  end

  def part1(workflows, parts) do
    parts
    |> Enum.map(&apply_workflows(&1, workflows))
    |> Enum.filter(& &1)
    |> Enum.map(fn %{x: x, m: m, a: a, s: s} -> x + m + a + s end)
    |> Enum.sum()
  end

  def part2(input) do
    [workflows, _] = input |> String.split("\n\n")

    workflows
    |> String.split()
    |> Enum.map(&parse_workflows(&1, :no_func))
    |> Map.new()
    |> calculate_combinations
    |> Enum.filter(fn
      {_, "A"} -> true
      _ -> false
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(fn map -> Map.values(map) |> Enum.map(&Range.size/1) |> Enum.product() end)
    |> Enum.sum()
  end

  def calculate_combinations(workflows) do
    calculate_combinations(
      workflows,
      %{x: 1..4000, m: 1..4000, a: 1..4000, s: 1..4000},
      "in"
    )
  end

  @doc """
  compare the current struct with the comparison, and slice the given key into two structs
  for example
  struct = Day19{x: 1..4000, m: 1..4000, a: 1..4000, s: 1..4000}
  the comparison is x < 1000 rhf
  this yields two structs
  Day19{struct | x: 1..999} going on to rhf
  and Day19{struct | x:1000..4000} going on to the next comparison
  we then collect all of structs that make it to an A take a product of their sizes
  and sum those up
  """
  def calculate_combinations(_workflows, struct, "A"), do: {struct, "A"}
  def calculate_combinations(_workflows, _struct, "R"), do: nil

  def calculate_combinations(workflows, struct, key) do
    Map.get(workflows, key)
    |> Enum.reduce([struct], fn
      _comparison, [nil | _] = acc ->
        acc

      comparison, [previous_struct | _] = acc ->
        result =
          case comparison do
            {field, "<", value, loc} ->
              if previous_struct[field].last < value do
                [
                  nil,
                  calculate_combinations(workflows, previous_struct, loc)
                ]
              else
                [
                  %{previous_struct | field => value..previous_struct[field].last},
                  calculate_combinations(
                    workflows,
                    %{previous_struct | field => previous_struct[field].first..(value - 1)},
                    loc
                  )
                ]
              end

            {field, ">", value, loc} ->
              if previous_struct[field].first > value do
                [
                  nil,
                  calculate_combinations(workflows, previous_struct, loc)
                ]
              else
                [
                  %{previous_struct | field => previous_struct[field].first..value},
                  calculate_combinations(
                    workflows,
                    %{previous_struct | field => (value + 1)..previous_struct[field].last},
                    loc
                  )
                ]
              end

            loc when is_binary(loc) ->
              [nil, calculate_combinations(workflows, previous_struct, loc)]
          end

        result ++ acc
    end)
    |> List.flatten()
    |> Enum.filter(& &1)
  end

  def apply_workflows(struct, workflows) do
    apply_workflows(struct, workflows, "in")
  end

  def apply_workflows(_struct, _workflows, "R"), do: nil
  def apply_workflows(struct, _workflows, "A"), do: struct

  def apply_workflows(struct, workflows, key) do
    functions = Map.get(workflows, key)

    result =
      functions
      |> Enum.reduce_while(nil, fn
        function, nil ->
          {:cont, function.(struct)}

        _function, next_loc ->
          {:halt, next_loc}
      end)

    apply_workflows(struct, workflows, result)
  end
end
