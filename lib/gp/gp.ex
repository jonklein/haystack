defmodule GP do
  defstruct population: [],
    interpreter: %{},
    cases: [],
    generation: 0,
    tournamentSize: 15,
    mutationRate: 0.40,
    crossoverRate: 0.55,
    mutationProbability: 0.1,
    solutionThreshold: 0.2,
    individualSize: 20,
    populationSize: 1000


  def configure(gp, []) do
    gp
  end

  def configure(gp, [{:individualSize, value} | t]) do
    IO.inspect("Individual size: #{value}")
    configure(%{gp | individualSize: value}, t)
  end

  def configure(gp, [{:populationSize, value} | t]) do
    IO.inspect("Population size: #{value}")
    configure(%{gp | populationSize: value}, t)
  end

  def configure(gp, [{:tournamentSize, value} | t]) do
    IO.inspect("Tournament size: #{value}")
    configure(%{gp | tournamentSize: value}, t)
  end

  def build(cases, options \\ []) do
    IO.inspect(cases)
    build_population(configure(%GP{interpreter: Interpreter.build(), cases: cases}, options))
  end

  def build_population(gp) do
    %{gp | population: Enum.map(1..gp.populationSize, fn _ -> Individual.build(gp.interpreter, gp.individualSize) end)}
  end

  def evaluate(gp) do
    %{gp | population: Enum.map(gp.population, fn i -> evaluate(gp, i) end)}
  end

  def evaluate(gp, individual) do
    fitness = Enum.reduce(gp.cases, 0, fn ([input, output], acc) ->
      i = Interpreter.execute(%{gp.interpreter | fstack: [], estack: [], finput: input}, individual.code)

      result = case i.fstack do
        [ h | _ ] -> h
        [] -> 0
      end

      acc + abs(result - output)
    end)

    %{individual | fitness: fitness}
  end

  def tournament(gp) do
    hd(Enum.take_random(gp.population, gp.tournamentSize)
      |> Enum.sort(&(&1.fitness <= &2.fitness)))
  end

  def next_individual(gp) do
    r = :rand.uniform()

    cond do
      r < gp.mutationRate -> Individual.mutate(tournament(gp), gp.interpreter, gp.mutationProbability)
      r < gp.mutationRate + gp.crossoverRate -> Individual.crossover(tournament(gp), tournament(gp))
      true -> tournament(gp)
    end
  end

  def generation(gp) do
    %{gp | generation: gp.generation + 1, population: Enum.map(gp.population, fn _ -> next_individual(gp) end)}
  end

  def report(gp) do
    best = hd(Enum.sort(gp.population, &(&1.fitness <= &2.fitness)))

    IO.puts("Generation: #{gp.generation} - #{Enum.count(gp.population)}")
    IO.puts("Best individual: #{best.fitness} - #{Enum.count(best.code)}")
    IO.inspect(best)
    IO.puts("\n")

    gp
  end

  def steps(gp, 0) do
    gp
  end

  def steps(gp, max) do
    gp = evaluate(gp)
      |> report

    best = hd(Enum.sort(gp.population, &(&1.fitness <= &2.fitness)))

    cond do
      best.fitness < gp.solutionThreshold -> gp
      true -> steps(generation(gp), max - 1)
    end
  end
end
