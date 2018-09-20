defmodule BattleNetwork.Tanks.Captain do
  use GenServer
  alias BattleNetwork.Tanks.Sergeant

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast(:action, sergeants) do
    for sergeant <- sergeants do
      Sergeant.act(sergeant)
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
    {:ok, %{"id" => id}} = BattleNetwork.Link.post("https://api.battletank.nl/addplayer", sergeant)
    sergeant = %Sergeant{sergeant | id: id}
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

  def add_sergeant(name) do
    endpoint = "https://battletank.nl/#{name}"
    #fetch id
    id = name
    GenServer.cast(__MODULE__, {:add, %Sergeant{name: name, id: id, command: %{}, health: 100, endpoint: endpoint}})
  end

  def update_sergeant(sergeant) do
    GenServer.cast(__MODULE__, {:update, sergeant})
  end

  def commands do
    GenServer.call(__MODULE__, :commands)
  end
end
