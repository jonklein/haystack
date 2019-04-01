defmodule Haystack do
  use Application

  def start(_type, _args) do
    IO.inspect("start")
    GP.build(Enum.map(1..15, fn i -> [i, 5*i*i + 2*i + 8] end), tournamentSize: 12, populationSize: 1200, individualSize: 30)
      |> GP.steps(300)
  end
end
