defmodule LiveViewStudio.LightServer do
  use GenServer

  alias LiveViewStudio.PubSub

  @default_brightness 10

  def init(_opts) do
    Phoenix.PubSub.subscribe(PubSub, "live_view_studio:presence")

    state = %{}

    {:ok, state}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def subscribe(socket, session_id) do
    {:ok, _} = LiveViewStudio.Presence.track(self(), "live_view_studio:presence", session_id, %{
      session_id: session_id,
      joined_at: :os.system_time(:seconds)
    })
    Phoenix.PubSub.subscribe(PubSub, "light_level:#{session_id}")
  end

  def set_brightness(session_id, brightness) do
    GenServer.cast(__MODULE__, {:set_brightness, session_id, brightness})
  end

  def get_brightness(session_id) do
    GenServer.call(__MODULE__, {:get_brightness, session_id})
  end

  # Internal Interface

  def handle_cast({:set_brightness, session_id, brightness}, state) do
    Phoenix.PubSub.broadcast(PubSub, "light_level:#{session_id}", {:updated_brightness, brightness})
    {:noreply, Map.put(state, session_id, brightness)}
  end

  def handle_call({:get_brightness, session_id}, _from, state) do
    brightness = Map.get(state, session_id, @default_brightness)
    {:reply, brightness, state}
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, state) do
    state =
      state
      |> handle_leaves(diff.leaves)

    {:noreply, state}
  end

  def handle_leaves(state, leaves) do
    Enum.reduce(leaves, state, fn {session_id, _}, state ->
      LiveViewStudio.Presence.list("live_view_studio:presence")
      |> Map.get(session_id)
      |> case do
        nil -> Map.delete(state, session_id)
        _   -> state
      end
    end)
  end
end
