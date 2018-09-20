defmodule BattleNetwork.Field.Field do
  use Agent

  def start_link(field) do
    Agent.start_link(fn -> field end, name: __MODULE__)
  end

  def get() do
    Agent.get(__MODULE__, & &1)
  end

  def set(field) do
    Agent.update(__MODULE__, fn _ -> field end)
  end
end
