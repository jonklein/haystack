defmodule Runner do
  use GenServer

  def start_link(%{interpreter: interpreter, cases: cases, pid: pid}) do
    GenServer.start_link(__MODULE__, %{interpreter: interpreter, cases: cases, pid: pid})
  end

  def init(%{interpreter: interpreter, cases: cases, pid: pid}) do
    {:ok, %{interpreter: interpreter, cases: cases, pid: pid}}
  end

  def run(runner, individual) do
    GenServer.cast(runner, {:run, individual})
  end

  def handle_cast({:run, individual}, state) do
    send(state.pid, {:fitness, %{individual | fitness: GP.evaluate(state.cases, state.interpreter, individual)}})
    {:noreply, state}
  end
end
