
defmodule Interpreter do
  defstruct fstack: [], cstack: [], instructions: %{}

  def build do
    %Interpreter{}
      |> register_instruction("float.*", &Instructions.fmul/1)
      |> register_instruction("float.+", &Instructions.fadd/1)
      |> register_instruction("float./", &Instructions.fdiv/1)
      |> register_instruction("float.-", &Instructions.fsub/1)
  end

  def register_instruction(i, name, inst) do
    %{i | instructions: Map.put(i.instructions, name, inst)}
  end

  def step(i, 0) do
    i
  end

  def step(i, limit) do
    case i.cstack do
      [] -> i
      [instruction | rest] ->
        i = %{i | cstack:  rest}

        i = cond do
          is_list(instruction) -> Enum.reduce(Enum.reverse(instruction), i, fn a, i -> %{i | cstack: [a | i.cstack]} end)
          is_number(instruction) -> Instructions.fconst(i, instruction)
          i.instructions[instruction] -> i.instructions[instruction].(i)
        end

        step(i, limit - 1)
    end
  end

  def execute(i, program) when is_list(program) do
    step(%{i | cstack: [ program | i.cstack ]}, 100)
  end

  def execute(i, program) when is_bitstring(program) do
    p = Enum.map(String.split(program, " ", trim: true), fn t ->
      case Float.parse(t) do
        {n, ""} -> n
        _ -> t
      end
    end)

    execute(i, p)
  end
end
