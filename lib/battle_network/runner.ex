defmodule BattleNetwork.Runner do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{status: :pending}, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def handle_info(:start, state) do
    Process.send_after(
      self(),
      :run_frame,
      100
    )
    {:noreply, %{status: :started} }
  end

  def handle_info(:stop, state), do: {:noreply, %{status: :stopped}}

  def handle_info(:run_frame, %{status: :started} = state) do
    Process.send_after(
      self(),
      :run_frame,
      100
    )

    {:noreply, state}
  end

  def handle_info(:run_frame, state), do: {:noreply, state}

  def handle_info(_, state), do: {:noreply, state}

  defp schedule_next_reindex() do
    Process.send_after(self(), :reindex, 60 * 60 * 1000)
  end

  defp schedule_next_refresh() do
    Process.send_after(self(), :refresh, 60 * 1000)
  end
end
