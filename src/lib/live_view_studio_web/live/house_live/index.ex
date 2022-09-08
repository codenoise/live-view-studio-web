defmodule LiveViewStudioWeb.HouseLive.Index do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Households
  alias LiveViewStudio.Households.House

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :houses, list_houses())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit House")
    |> assign(:house, Households.get_house!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New House")
    |> assign(:house, %House{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Houses")
    |> assign(:house, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    house = Households.get_house!(id)
    {:ok, _} = Households.delete_house(house)

    {:noreply, assign(socket, :houses, list_houses())}
  end

  defp list_houses do
    Households.list_houses()
  end
end
