
defmodule Generator do
  def build(interpreter, max) do
    keys = Map.keys(interpreter.instructions)

    Enum.map(1..max, fn _ ->
      r = Enum.random(0..1)

      cond do
        r < 0.15 -> :rand.uniform() * 10.0
        true -> Enum.at(Enum.shuffle(keys), 0)
      end
    end)
  end
end
