defmodule BattleNetwork.Tanks.Sergeant do
  use GenServer
  alias BattleNetwork.Tanks.{Captain}
  alias BattleNetwork.Field.{Marshall}

  defstruct [:id, :name, :health, :command, :endpoint]

  def start_link(sergeant) do
    GenServer.start_link(__MODULE__, sergeant, name: sergeant_id(sergeant.id))
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:act, _from, state) do
    with {:ok, command} <- BattleNetwork.Link.post(state.endpoint, Marshall.get) do
      refresh = Map.put(state, :command, command)
      {:reply, refresh, refresh}
    else
      _ -> {:reply, state, state}
    end
  end

  def act(sergeant) do
    sergeant = GenServer.call(sergeant_id(sergeant.id), :act)
    Captain.update_sergeant(sergeant)
  end

  def sergeant_id(id) do
    String.to_atom("sergeant_#{id}")
  end
end
