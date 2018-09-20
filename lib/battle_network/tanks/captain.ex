defmodule BattleNetwork.Tanks.Captain do
  use GenServer
  alias BattleNetwork.Tanks.Sergeant

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast(:action, _from, sergeants) do
    for sergeant <- sergeants do
      sergeant.act(sergeant)
    end
    {:noreply, sergeants}
  end

  def handle_call(:commands, _from, sergeants) do
    commands = for sergeant <- sergeants do
      Map.merge(Map.get(sergeant, :command), %{player_id: sergeant.id})
    end
    {:reply, commands, sergeants}
  end

  def handle_cast({:add, sergeant}, sergeants) do
    Sergeant.start_link(sergeant)
    {:noreply, [sergeant | sergeants]}
  end

  def handle_cast({:update, %{id: id} = sergeant}, sergeants) do
    sergeants = Enum.map(sergeants, fn
      %{id: ^id} -> sergeant
      s -> s
    end)
    {:noreply, sergeants}
  end

  def action() do
    GenServer.cast(__MODULE__, :action)
  end

  def add_sergeant(sergeant) do
    GenServer.cast(__MODULE__, {:add, sergeant})
  end

  def update_sergeant(sergeant) do
    GenServer.cast(__MODULE__, {:update, sergeant})
  end

  def commands do
    GenServer.call(__MODULE__, :commands)
  end
end
