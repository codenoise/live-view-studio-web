defmodule LiveViewStudio.LightServer do
  use GenServer

  alias LiveViewStudio.PubSub
  alias LiveViewStudio.Households.Lights

  require Logger

  def init(_opts) do
    Phoenix.PubSub.subscribe(PubSub, "live_view_studio:presence")

    state = %{}

    {:ok, state}
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def subscribe(_socket, light_id) do
    {:ok, _} = LiveViewStudio.Presence.track(self(), "live_view_studio:presence", session_id(light_id), %{
      light_id: session_id(light_id),
      joined_at: :os.system_time(:seconds)
    })
    Logger.info("Subscribing to light_level:#{session_id(light_id)}")
    Phoenix.PubSub.subscribe(PubSub, "light_level:#{session_id(light_id)}")
  end

  def set_brightness(light_id, brightness) do
    GenServer.cast(__MODULE__, {:set_brightness, light_id, brightness})
  end

  def get_brightness(light_id) do
    GenServer.call(__MODULE__, {:get_brightness, light_id})
  end

  # Internal Interface

  def handle_cast({:set_brightness, light_id, brightness}, state) do
    Logger.info("Broadcasting to 'light_level:#{session_id(light_id)}' with brightness #{brightness}")
    Phoenix.PubSub.broadcast(PubSub, "light_level:#{session_id(light_id)}", {:updated_brightness, brightness})
    Lights.update_brightness!(light_id, brightness)
    {:noreply, Map.put(state, session_id(light_id), brightness)}
  end

  def handle_call({:get_brightness, light_id}, _from, state) do
    brightness = Map.get_lazy(state, session_id(light_id), fn -> Lights.get_light!(light_id).brightness end )
    {:reply, brightness, state}
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, state) do
    state =
      state
      |> handle_leaves(diff.leaves)

    {:noreply, state}
  end

  def handle_leaves(state, leaves) do
    Enum.reduce(leaves, state, fn {light_id, _}, state ->
      LiveViewStudio.Presence.list("live_view_studio:presence")
      |> Map.get(session_id(light_id))
      |> case do
        nil -> Map.delete(state, session_id(light_id))
        _   -> state
      end
    end)
  end

  defp session_id(light_id), do: "light-#{light_id}"
end
