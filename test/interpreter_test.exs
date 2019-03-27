defmodule InterpreterTest do
  use ExUnit.Case, async: true
  doctest Interpreter

  test "builds" do
    p = Interpreter.build()

    assert p.fstack == []
  end

  test "runs list programs" do
    p = Interpreter.build()
      |> Interpreter.execute([10, [ 20 ], 30, "float.*"])

    assert p.fstack == [600, 10]
  end

  test "runs string programs" do
    p = Interpreter.build()
      |> Interpreter.execute("10 (20) 30 float.*")

    assert p.fstack == [600, 10]
  end
end
