defmodule InstructionsTest do
  use ExUnit.Case, async: true
  doctest Instructions

  test "it noop with an insufficient stack size" do
    p = %Interpreter{}
      |> Instructions.fconst(10)
      |> Instructions.fadd()

    assert p.fstack == [10]
  end

  test "it pushes numbers" do
    p = %Interpreter{}
      |> Instructions.fconst(10)
      |> Instructions.fconst(20)

    assert p.fstack == [20, 10]
  end

  test "it adds numbers" do
    p = %Interpreter{}
      |> Instructions.fconst(10)
      |> Instructions.fconst(20)
      |> Instructions.fadd()

    assert p.fstack == [30]
  end

  test "it subtracts numbers" do
    p = %Interpreter{}
      |> Instructions.fconst(10)
      |> Instructions.fconst(20)
      |> Instructions.fsub()

    assert p.fstack == [-10]
  end

  test "it multiplies numbers" do
    p = %Interpreter{}
      |> Instructions.fconst(10)
      |> Instructions.fconst(20)
      |> Instructions.fmul()

    assert p.fstack == [200]
  end

  test "it divides numbers" do
    p = %Interpreter{}
      |> Instructions.fconst(10)
      |> Instructions.fconst(20)
      |> Instructions.fdiv()

    assert p.fstack == [0.5]
  end

  test "it pops numbers" do
    p = %Interpreter{}
      |> Instructions.fconst(10)
      |> Instructions.fconst(20)
      |> Instructions.fpop()

    assert p.fstack == [10.0]
  end

  test "it dups numbers" do
    p = %Interpreter{}
    |> Instructions.fconst(10)
    |> Instructions.fconst(20)
    |> Instructions.fdup()

    assert p.fstack == [20.0, 20.0, 10.0]
  end

end
