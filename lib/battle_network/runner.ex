defmodule BattleNetwork.Runner do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{status: :pending}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast(:start, state) do
    Process.send_after(
      self(),
      :run_frame,
      100
    )
    {:noreply, %{status: :started} }
  end

  def handle_cast(:stop, state), do: {:noreply, %{status: :stopped}}

  def handle_info(:run_frame, %{status: :started} = state) do
    BattleNetwork.Tanks.Captain.action

    Process.send_after(
      self(),
      :run_frame,
      100
    )

    {:noreply, state}
  end

  def handle_info(:run_frame, state), do: {:noreply, state}

  def handle_info(_, state), do: {:noreply, state}

  def start do
    GenServer.cast(__MODULE__, :start)
  end

  def stop do
    GenServer.cast(__MODULE__, :stop)
  end
end
