defmodule Twitter.Collector do
  @moduledoc """
  Maintains a list of %Twitter.Tweets{} that have been
  retrieved from the Twitter web API, and refreshes the list
  on a set interval.
  """

  use GenServer

  @name Collector
  @client Application.get_env(:twitter, :client)
  @refresh_time 10_000

  ## Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def list do
    GenServer.call(@name, :list)
  end

  ## Server Callbacks

  @impl true
  def init(:ok) do
    schedule_refresh()
    {:ok, []}
  end

  @impl true
  def handle_call(:list, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast(:refresh, state) do
    Process.send(self(), :refresh, [])
    {:no_reply, state}
  end

  @impl true
  def handle_info(:refresh, state) do
    case @client.get_recent_tweets() do
      {:ok, tweets} ->
        schedule_refresh(@refresh_time)
        {:noreply, tweets}

      {:error, reason} ->
        raise inspect(reason)
        {:noreply, state}
    end
  end

  ## Helper Functions

  defp schedule_refresh(time \\ 0) do
    Process.send_after(self(), :refresh, time)
  end
end
