defmodule BattleNetwork.Tanks.Captain do
  use GenServer
  alias BattleNetwork.Tanks.Sergeant

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast(:action, _from, sergeants) do
    {:noreply, sergeants}
  end

  def handle_call(:commands, _from, sergeants) do
    commands = for sergeant <- sergeants do
      Map.merge(sergeant.command, %{player_id: sergeant.id})
    end

    {:reply, commands, sergeants}
  end

  def handle_cast({:add, sergeant}, _from, sergeants) do
    {:noreply, [sergeant | sergeants]}
  end

  def handle_cast({:update, %{id: id} = sergeant}, _from, sergeants) do
    sergeants = Enum.map(fn
      %{id: ^id} -> sergeant
      s -> s
    end)
    {:noreply, sergeants}
  end

  def action() do
    GenServer.call(__MODULE__, :action)
  end

  def add_sergeant(sergeant) do
    GenServer.call(__MODULE__, :add)
  end

  def update_sergeant(sergeant) do
    GenServer.call(__MODULE__, :update)
  end

  def commands do
    GenServer.call(__MODULE__, :commands)
  end
end
