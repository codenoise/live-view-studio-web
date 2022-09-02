defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.LightServer

  def mount(_params, %{"session_id" => session_id}, socket) do
    if connected?(socket) do
      LightServer.subscribe(socket, session_id)
    end

    assigns = [
      session_id: session_id,
      brightness: LightServer.get_brightness(session_id)
    ]

    {:ok, assign(socket, assigns)}
  end

  # def render(assigns) do
  #   Phoenix.View.render(LiveViewStudioWeb.PageView, "light.html", assigns)
  # end

  def handle_event("on", _, socket) do
    LightServer.set_brightness(socket.assigns.session_id, 100)
    {:noreply, assign(socket, :brightness, 100)}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))
    LightServer.set_brightness(socket.assigns.session_id, socket.assigns.brightness)
    {:noreply, socket}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))
    LightServer.set_brightness(socket.assigns.session_id, socket.assigns.brightness)
    {:noreply, socket}
  end

  def handle_event("off", _, socket) do
    LightServer.set_brightness(socket.assigns.session_id, 0)
    {:noreply, assign(socket, :brightness, 0)}
  end

  def handle_info({:updated_brightness, brightness}, socket) do
    {:noreply, assign(socket, :brightness, brightness)}
  end
end
