defmodule Individual do
  defstruct code: [], fitness: 0.0

  def build(interpreter, size) do
    %Individual{code: Generator.build(interpreter, size), fitness: 0}
  end

  def crossover(i1, i2) do
    idx1 = trunc(:rand.uniform() * Enum.count(i1.code))
    %Individual{code: Enum.slice(i1.code, 0, idx1) ++ Enum.slice(i2.code, idx1, Enum.count(i2.code) - idx1)}
  end

  def mutate(i, interpreter, rate) do
    %{i | code:
      Enum.map(i.code, fn i ->
        cond do
          :rand.uniform() < rate -> Generator.point(interpreter)
          true -> i
        end
      end)}
  end
end
