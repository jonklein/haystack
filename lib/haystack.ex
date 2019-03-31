defmodule Haystack do
  def hello do
    :world
  end
end



# GP.build(1000, Enum.map(1..15, fn i -> [i, 5*i*i + 2*i + 8] end))
#   |> GP.steps(300)

GP.build(1000, Enum.map(1..15, fn i -> [i, 2*i + 8] end))
  |> GP.steps(300)
