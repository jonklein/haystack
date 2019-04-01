
defmodule Interpreter do
  defstruct fstack: [], estack: [], finput: 0.0, instructions: %{}

  def build do
    %Interpreter{}
      |> register_instruction("float.*", &Instructions.fmul/1)
      |> register_instruction("float.+", &Instructions.fadd/1)
      |> register_instruction("float./", &Instructions.fdiv/1)
      |> register_instruction("float.-", &Instructions.fsub/1)
      |> register_instruction("float.dup", &Instructions.fdup/1)
      |> register_instruction("float.pop", &Instructions.fpop/1)
      |> register_instruction("float.noop", &Instructions.fnoop/1)
      |> register_instruction("float.input", &Instructions.finput/1)
  end

  def register_instruction(i, name, inst) do
    %{i | instructions: Map.put(i.instructions, name, inst)}
  end

  def step(i, 0) do
    i
  end

  def step(i, limit) do
    case i.estack do
      [] -> i
      [instruction | rest] ->
        i = %{i | estack: rest}

        i = cond do
          is_list(instruction) -> Enum.reduce(Enum.reverse(instruction), i, fn a, i -> %{i | estack: [a | i.estack]} end)
          is_number(instruction) -> Instructions.fconst(i, instruction)
          i.instructions[instruction] -> i.instructions[instruction].(i)
        end

        step(i, limit - 1)
    end
  end

  def execute(i, program) when is_list(program) do
    step(%{i | estack: [ program | i.estack ]}, 100)
  end

  def execute(i, program) when is_bitstring(program) do
    execute(i, parse(program))
  end

  def parse(program) when is_bitstring(program) do
    tokenize(program)
      |> parse
  end

  def parse(tokens) when is_list(tokens) do
    # Reduce with an list-of-lists accumulator representing the current
    # stack of nested token lists.  On open-paren, push a new empty list
    # to the accumulator.  On close-paren, pop the top of the accumulator
    # stack and push it onto the next list down.

    hd(Enum.reduce(tokens, [[]], fn (token, [ h | t ]) ->
        case token do
          "(" -> [ [] | [ h | t ] ]
          ")" -> [ second | t ] = t; [ second ++ [h] | t ]
          _ ->
            case Float.parse(token) do
              {n, _} -> [ h ++ [n] | t ]
              :error -> [ h ++ [token] | t ]
            end
        end
    end))
  end

  defp tokenize(program) do
    List.flatten(Regex.scan(~r/(?:[\)\(]|[^\s\(\)]+)/, program))
  end
end
