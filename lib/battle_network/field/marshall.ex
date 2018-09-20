defmodule BattleNetwork.Field.Marshall do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get() do
    Agent.get(__MODULE__, & &1)
  end

  def set(field) do
    Agent.update(__MODULE__, fn _ -> field end)
  end
end
