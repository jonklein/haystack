defmodule IndividualTest do
  use ExUnit.Case, async: true
  doctest Individual

  test "it builds" do
    int = Interpreter.build()
    i = Individual.build(int, 30)

    assert Enum.count(i.code) > 0
  end

  test "it does crossover" do
    int = Interpreter.build()
    i1 = Individual.build(int, 30)
    i2 = Individual.build(int, 30)

    i3 = Individual.crossover(i1, i2)

    # IO.puts("Crossover")
    # IO.inspect(i1)
    # IO.inspect(i2)
    # IO.puts("OUT")
    # IO.inspect(i3)

    assert Enum.count(i3.code) > 0
  end

  test "it does mutation" do
    int = Interpreter.build()
    i1 = Individual.build(int, 30)

    i2 = Individual.mutate(i1, int, 0.1)
    #
    # IO.puts("Mutate")
    # IO.inspect(i1)
    # IO.puts("OUT")
    # IO.inspect(i2)

    assert Enum.count(i2.code) > 0
  end
end
