defmodule Haystack do
  use Application

  def start(_type, _args) do
    IO.inspect("start")

    Task.start(fn ->
      GP.build(Enum.map(1..50, fn i -> [i, 5*i*i + 2*i + 8] end), tournamentSize: 12, populationSize: 1200, individualSize: 40)
        |> GP.steps(300)
    end)
  end
end
