
defmodule Instructions do
  def pop(p, n) do
    f = Enum.take(p.fstack, n)
    {f, %{p | fstack: Enum.take(p.fstack, -(length(p.fstack) - n))}}
  end

  def fadd(p) do
    case pop(p, 2) do
      {[x, y], pp} -> fconst(pp, x + y)
      {_, _} -> p
    end
  end

  def fsub(p) do
    case pop(p, 2) do
      {[x, y], pp} -> fconst(pp, y - x)
      {_, _} -> p
    end
  end

  def fmul(p) do
    case pop(p, 2) do
      {[x, y], pp} -> fconst(pp, x * y)
      {_, _} -> p
    end
  end

  def fdiv(p) do
    case pop(p, 2) do
      {[0.0, _], pp} -> fconst(pp, 0.0)
      {[x, y], pp} -> fconst(pp, y / x)
      {_, _} -> p
    end
  end

  @spec fconst(Push, float) :: Push
  def fconst(p, f) do
    %{p | fstack: [f/1.0 | p.fstack]}
  end
end
