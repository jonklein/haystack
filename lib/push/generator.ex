
defmodule Generator do
  def build(interpreter, max) do
    keys = Map.keys(interpreter.instructions)

    Enum.map(1..max, fn _ ->
      Enum.at(Enum.shuffle(keys), 0)
    end)
  end
end
