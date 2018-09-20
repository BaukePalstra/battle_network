defmodule BattleNetwork.Tanks.Sergeant do
  use GenServer
  alias BattleNetwork.Tanks.Sergeant
  defstruct [:id, :name, :health, :command]

  def start_link(sergeant) do
    GenServer.start_link(__MODULE__, sergeant, name: sergeant.id)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:act, _from, state) do
    # Http request state.endpoint
    command = %{forward: 5}
    state = Map.put(state, :command, command)
    {:reply, state, state}
  end

  def act(id, state) do
    GenServer.call(id, :act)
  end

  def sergeant_id(id) do
    String.to_atom("sergeant_#{id}")
  end
end
