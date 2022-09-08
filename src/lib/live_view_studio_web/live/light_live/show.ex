defmodule LiveViewStudioWeb.LightLive.Show do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Households
  alias LiveViewStudio.Households.Lights
  alias LiveViewStudio.LightServer

  require Logger
  @impl true
  def mount(_params, session, socket) do
    Logger.debug("mounting show")
    {:ok, socket
           |> assign_current_user(session)
           |> assign(:brightness, 10)
    }
  end

  @impl true
  def handle_params(%{"id" => id, "house_id" => house_id}, _, socket) do

    Logger.debug("Subscribing with light id #{id}")
    LightServer.subscribe(socket, id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:light, Lights.get_light!(id))
     |> assign(:house, Households.get_house!(house_id))
     |> assign(:brightness, LightServer.get_brightness(id))
    }
  end

  @impl true
  def handle_event("on", _, socket) do
    LightServer.set_brightness(socket.assigns.light.id, 100)
    {:noreply, assign(socket, :brightness, 100)}
  end

  @impl true
  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))
    LightServer.set_brightness(socket.assigns.light.id, socket.assigns.brightness)
    {:noreply, socket}
  end

  @impl true
  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))
    LightServer.set_brightness(socket.assigns.light.id, socket.assigns.brightness)
    {:noreply, socket}
  end

  @impl true
  def handle_event("off", _, socket) do
    LightServer.set_brightness(socket.assigns.light.id, 0)
    {:noreply, assign(socket, :brightness, 0)}
  end

  @impl true
  def handle_info({:updated_brightness, brightness}, socket) do
    Logger.info("in handle_info(:update_brightness) with brightness of #{brightness}")
    {:noreply, assign(socket, :brightness, brightness)}
  end

  defp page_title(:show), do: "Show Light"
  defp page_title(:edit), do: "Edit Light"
end
