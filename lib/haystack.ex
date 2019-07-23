defmodule Haystack do
  use Application

  def load_data(file) do
    Poison.decode!(File.read!(file))
  end

  def main(args) do
    data = load_data(Enum.at(args, 0))
    IO.inspect(data)

    Task.start(fn ->
      GP.build(data, tournamentSize: 12, populationSize: 1200, individualSize: 40)
        |> GP.steps(300)
    end)

    :timer.sleep(:infinity)
  end
end
