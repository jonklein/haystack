defmodule Haystack do
  def hello do
    :world
  end
end

IO.inspect(Generator.build(Interpreter.build(), 10))
