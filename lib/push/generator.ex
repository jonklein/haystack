
defmodule Generator do
  def build(interpreter, max) do
    Enum.map(1..max, fn _ -> point(interpreter) end)
  end

  def point(interpreter) do
    r = :rand.uniform()

    cond do
      r < 0.1 -> trunc(:rand.uniform() * 20.0) - 10.0
      true -> Enum.random(Map.keys(interpreter.instructions))
    end
  end
end
