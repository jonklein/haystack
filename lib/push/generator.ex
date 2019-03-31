
defmodule Generator do
  def build(interpreter, max) do
    Enum.map(1..max, fn _ -> point(interpreter) end)
  end

  def point(interpreter) do
    keys = Map.keys(interpreter.instructions)

    r = :rand.uniform()

    cond do
      r < 0.5 -> trunc(:rand.uniform() * 30.0) - 15.0
      true -> Enum.random(keys)
    end
  end
end
