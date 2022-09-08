defmodule LiveViewStudioWeb.LightLive.Index do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Households
  alias LiveViewStudio.Households.Lights
  alias LiveViewStudio.Households.Light

  @impl true
  def mount(%{"house_id" => house_id}, _session, socket) do
    socket = assign(socket, :house, Households.get_house!(house_id))

    {:ok, assign(socket, :lights, list_lights())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Light")
    |> assign(:light, Lights.get_light!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Light")
    |> assign(:light, %Light{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Lights")
    |> assign(:light, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id, "house_id" => house_id}, socket) do
    _house = Households.get_house!(house_id)
    light = Lights.get_light!(id)
    {:ok, _} = Lights.delete_light(light)

    {:noreply, assign(socket, :lights, list_lights())}
  end

  defp list_lights do
    Lights.list_lights()
  end
end
