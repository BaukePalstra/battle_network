defmodule BattleNetwork.Tanks.Captain do
  use GenServer
  alias BattleNetwork.Tanks.Sergeant

  def start_link(_) dostate
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(:action, _from, sergeants) do
    # Http request state.endpoint
    for sergeant <- sergeants do
      Sergeant.act(Map.get(sergeant.id))
    end

    {:reply, response, Map.put(state, :command, command)}
  end

  def action() do
    GenServer.call(__MODULE__, :action)
  end

  defp sergeant_id(id) do
    String.to_atom("sergeant_#{id}")
  end
end
