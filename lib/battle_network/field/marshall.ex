defmodule BattleNetwork.Field.Marshall do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(args), do: {:ok, args}

  def handle_call(:get, _from, field) do
    {:reply, field, field}
  end

  def handle_cast({:resolve, commands}, field) do
    with {:ok, refresh} <- BattleNetwork.Link.post("https://api.battletank.nl/tick", %{commands: commands}) do
      {:noreply, refresh}
    else
      _ -> {:noreply, field}
    end
  end

  def get() do
    GenServer.call(__MODULE__, :get)
  end

  def resolve(commands) do
    GenServer.cast(__MODULE__, {:resolve, commands})
  end
end
