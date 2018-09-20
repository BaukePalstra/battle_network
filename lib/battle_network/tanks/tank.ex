defmodule BattleNetwork.Tank.Tank do
  use Agent

  def start_link(tank, id) do
    Agent.start_link(fn -> %{tank} end, name: tank_id(id))
  end

  def last_command(id) do
    Agent.get(tank_id(id), &Map.get(&1, :command))
  end

  def command(id, command) do
    Agent.set(tank_id(id), fn tank -> Map.set(tank, :command, command))
  end

  defp tank_id(id) do
    String.to_atom("tank_#{id}")
  end
end
