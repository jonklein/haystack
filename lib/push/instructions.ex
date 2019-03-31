
defmodule Instructions do
  def pop(p, n) do
    f = Enum.take(p.fstack, n)
    {f, %{p | fstack: Enum.take(p.fstack, -(length(p.fstack) - n))}}
  end

  def fnoop(p) do
    p
  end

  def fpop(p) do
    {_, p} = pop(p, 1)
    p
  end

  def fdup(p) do
    case pop(p, 1) do
      {[x], _} -> fconst(p, x)
      {_, _} -> p
    end
  end

  def fadd(p) do
    case pop(p, 2) do
      {[x, y], p} -> fconst(p, x + y)
      {_, _} -> p
    end
  end

  def fsub(p) do
    case pop(p, 2) do
      {[x, y], p} -> fconst(p, y - x)
      {_, _} -> p
    end
  end

  def fmul(p) do
    case pop(p, 2) do
      {[x, y], p} -> fconst(p, x * y)
      {_, _} -> p
    end
  end

  def fdiv(p) do
    case pop(p, 2) do
      {[0.0, _], p} -> fconst(p, 0.0)
      {[x, y], p} -> fconst(p, y / x)
      {_, _} -> p
    end
  end

  @spec fconst(Push, float) :: Push
  def fconst(p, f) do
    %{p | fstack: [f/1.0 | p.fstack]}
  end
end
